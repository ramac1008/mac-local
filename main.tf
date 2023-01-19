# Configure Kubernetes provider and connect to the Kubernetes API server
provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "docker-desktop"
}

# Create an Nginx pod
resource "kubernetes_pod" "alpine" {
  metadata {
    name = "terraform-example-alpine"
    labels = {
      app = "alpine"
    }
  }

  spec {
    container {
      image = "alpine:latest"
      name  = "example"
    }
  }
}

# Create an service
resource "kubernetes_service" "alpine" {
  metadata {
    name = "terraform-example-alpine"
  }
  spec {
    selector = {
      app = kubernetes_pod.alpine.metadata.0.labels.app
    }
    port {
      port        = 80
    }

    type = "NodePort"
  }

  depends_on = [
    kubernetes_pod.alpine
  ]
}