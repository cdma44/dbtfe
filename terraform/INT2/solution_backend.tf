terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "caku"  # 🔁 Change to your Terraform Cloud org name

    workspaces {
      name = "INT2"    # 🔁 Change to your Terraform Cloud workspace name
    }
  }
}