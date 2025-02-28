variable "project_name" {
  description = "The name of the application"
}

variable "grafana_password" {
  type        = string
  description = "Grafana admin password"
  sensitive   = true
  default     = ""  
}