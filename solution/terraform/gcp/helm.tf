provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}
resource "helm_release" "postgresql-ha" {
  name       = "postgresql-ha"

  repository = "https://charts.bitnami.com/bitnami"
  chart      = "postgresql-ha"
  values = [
          templatefile("values.yaml", {postgresql_template_password = "${var.postgresql_password}" }) 
          ]

  set {
    name  = "service.type"
    value = "ClusterIP"
  }

  #set {
  #  name  = "postgresql-ha.postgresql.password"
  #  value = var.postgresql_password
  #}
}
