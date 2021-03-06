provider "google" {
  project     = "docker-223805"
  region      = "europe-west1"
}

resource "google_container_cluster" "primary" {
  name               = "cluster-1"
  zone               = "europe-west1-d"
  
  enable_legacy_abac = true

  node_pool {
    name = "my-node-pool-1"
    node_count = 2
    node_config {
      machine_type = "g1-small"
      disk_size_gb = 20
    }
  }
  node_pool {
    name = "my-node-pool-2"
    node_count = 1
    node_config {
      machine_type = "n1-standard-2"
      disk_size_gb = 40
    }
  }
  master_auth {
    username = ""
    password = ""
  }
  addons_config {
  http_load_balancing {
    disabled = false
  }
  kubernetes_dashboard {
    disabled = false
  }
}
}
