terraform {
  required_providers {
    xenorchestra = {
      source = "vatesfr/xenorchestra"
    }
  }
  required_version = ">= 0.12"
  
}

provider "xenorchestra" {
  # Must be ws or wss
  url      = var.xo_url # Or set XOA_URL environment variable
  username = var.xo_user              # Or set XOA_USER environment variable
  password = var.xo_pass              # Or set XOA_PASSWORD environment variable

  insecure = true             # Or set XOA_INSECURE environment variable to any value
}