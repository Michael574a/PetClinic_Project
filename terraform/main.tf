terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # CONFIGURACIÓN OBLIGATORIA: Estado remoto para el trabajo en equipo
  backend "s3" {
    bucket         = "tu-bucket-terraform-utn-state" # Debe ser un nombre global único creado previamente
    key            = "prod/petclinic/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "tu-tabla-taller-locks" # Tabla DynamoDB para evitar colisiones de ejecución
  }
}

provider "aws" {
  region = var.aws_region
}

# Variable de región
variable "aws_region" {
  type    = string
  default = "us-east-1"
}

# Ejemplo de aprovisionamiento de una instancia EC2 donde se podría desplegar la app
resource "aws_instance" "production_server" {
  ami           = "ami-0c7217cdde317cfec" # Ubuntu Server 22.04 LTS en us-east-1
  instance_type = "t3.medium"             # Instancia recomendada para soportar apps en Java + Monitoreo

  tags = {
    Name        = "PetClinic-Production-Server"
    Environment = "Production"
    Project     = "Proyecto Integrador DevOps"
  }
}

# Salida para obtener la IP pública del servidor aprovisionado
output "server_public_ip" {
  value       = aws_instance.production_server.public_ip
  description = "IP pública de la instancia de producción creada"
}