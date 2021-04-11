provider "kubernetes" {
  config_path    = "~/.kube/config"
}

resource "kubernetes_namespace" "techchallengeapp" {
  metadata {
    name = "techchallengeapp"
  }
}

resource "kubernetes_secret" "techchallengeapp-secret" {
  metadata {
    name = "techchallengeapp-secret"
  }

  data = {
    VTT_DBHOST: "postgresql-ha-pgpool"
    VTT_DBNAME: "app"
    VTT_DBPASSWORD: var.postgresql_password
    #VTT_DBPASSWORD: dEVnbzAxUjRENA==
    #VTT_DBPASSWORD: WFpCWVdNVlpjNA==
    VTT_DBPORT: "5432"
    VTT_DBUSER: "postgres"
    VTT_LISTENHOST: "0.0.0.0"
    VTT_LISTENPORT: "3000"
  }
  type = "kubernetes.io/Opaque"
}
resource "kubernetes_job" "techchallengeapp-updatedb" {
  metadata {
    name = "techchallengeapp-updatedb"
  }
  spec {
    template {
      metadata {}
      spec {
        container {
          image = "servian/techchallengeapp:latest"
          name  = "techchallengeapp-updatedb"
          #command = ["/bin/sh"]
          #args = ["-c","env;"]
          args = ["updatedb -s"]
          env_from {
          secret_ref {
          name = "techchallengeapp-secret"
          }
          }
        }
        restart_policy = "Never"
      }
    }
    active_deadline_seconds  = 1200
    backoff_limit = 20
  }
}
resource "kubernetes_deployment" "techchallengeapp-deployment" {
  metadata {
    name = "techchallengeapp-deployment"
    labels = {
      app = "techchallengeapp"
    }
  }
  spec {
    replicas = 3

    selector {
      match_labels = {
        app = "techchallengeapp"
      }
    }

    template {
      metadata {
        labels = {
          app = "techchallengeapp"
        }
      }

      spec {
        container {
          image = "servian/techchallengeapp:latest"
          name  = "techchallengeapp"
          #command = ["/bin/sh"]
          #args = ["-c","env;"]
          args = ["serve"]
          env_from {
          secret_ref {
          name = "techchallengeapp-secret"
          }
          }
          liveness_probe {
            http_get {
              path = "/healthcheck"
              port = 3000
            }
            initial_delay_seconds = 10
            period_seconds        = 20
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "techchallengeapp-service" {
  metadata {
    name = "techchallengeapp-service"
  }
  spec {
    selector = {
    app = kubernetes_deployment.techchallengeapp-deployment.metadata.0.labels.app
    }
    session_affinity = "ClientIP"
    port {
      port        = 3000
      target_port = 80
    }
    type = "LoadBalancer"
  }
}
