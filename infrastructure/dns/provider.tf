terraform {
  required_providers {
    powerdns = {
      source  = "pan-net/powerdns"
      version = "~> 1.5"
    }
  }
}

provider "powerdns" {
  server_url = "http://127.0.0.1:8081/"
}
