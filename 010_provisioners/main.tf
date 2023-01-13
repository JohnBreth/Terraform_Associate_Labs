terraform {
  cloud {
    organization = "CyberInsightLab"

    workspaces {
      name = "provisioners"
    }
  }
}