

#Added CAS,KMS and container

resource "google_project_service" "cas_api" {
  service = "privateca.googleapis.com"
}

resource "google_project_service" "kms_api" {
  service = "cloudkms.googleapis.com"
}

resource "google_project_service" "container_api" {
  service = "container.googleapis.com"
}

# -------------------------------
# GKE Cluster with Workload Identity
# -------------------------------

resource "google_container_cluster" "primary" {
  name               = "gke-wi-cluster"
  location           = var.region
  remove_default_node_pool = true
  initial_node_count = 1

  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }
}

resource "google_container_node_pool" "primary_nodes" {
  name       = "primary-node-pool"
  location   = var.region
  cluster    = google_container_cluster.primary.name

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
    machine_type = "e2-medium"
  }

  initial_node_count = 1
}

# -------------------------------
# KMS KeyRing & CryptoKey
# -------------------------------

resource "google_kms_key_ring" "cas_ring" {
  name     = "cas-keyring"
  location = "global"
}

resource "google_kms_crypto_key" "cas_key" {
  name            = "cas-crypto-key"
  key_ring        = google_kms_key_ring.cas_ring.id
  rotation_period = "100000s"

  lifecycle {
    prevent_destroy = true
  }
}

# -------------------------------
# CAS CA Pool and CA
# -------------------------------

resource "google_privateca_ca_pool" "ca_pool" {
  name     = "sample-ca-pool"
  location = "us-central1"
  tier     = "DEVOPS"
  publishing_options {
    publish_ca_cert = true
    publish_crl     = true
  }
}

resource "google_privateca_certificate_authority" "self_signed_ca" {
  location                  = "us-central1"
  pool                      = google_privateca_ca_pool.ca_pool.name
  certificate_authority_id  = "self-signed-ca"
  type                      = "SELF_SIGNED"

  key_spec {
    cloud_kms_key_version = "${google_kms_crypto_key.cas_key.id}/cryptoKeyVersions/1"
  }

  config {
    subject_config {
      subject {
        common_name  = "my-self-signed-ca"
        organization = "db org"
      }
      subject_alt_name {
        dns_names = ["ca.example.com"]
      }
    }

    x509_config {
      key_usage {
        base_key_usage {
          cert_sign = true
          crl_sign  = true
        }
        extended_key_usage {
          server_auth = true
          client_auth = true
        }
      }

      ca_options {
        is_ca = true
        max_issuer_path_length = 0  # optional; 0 means this CA can only issue leaf certs
      }
    }
  }

  depends_on = [google_project_service.cas_api]
}


# -------------------------------
# GCP Service Account for cert-manager
# -------------------------------

resource "google_service_account" "cas_issuer_sa" {
  account_id   = "cert-manager-cas-issuer-sa"
  display_name = "Cert Manager CAS Issuer Service Account"
}

# Allow this SA to request certificates from the CA Pool
resource "google_privateca_ca_pool_iam_member" "issuer_binding" {
  ca_pool = google_privateca_ca_pool.ca_pool.id
  location = "us-central1"
  role    = "roles/privateca.certificateRequester"
  member  = "serviceAccount:${google_service_account.cas_issuer_sa.email}"
}

# Allow K8s SA to impersonate GCP SA (Workload Identity binding)
resource "google_service_account_iam_member" "workload_identity_binding" {
  service_account_id = google_service_account.cas_issuer_sa.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${var.project_id}.svc.id.goog[cert-manager/cert-manager]"
}