# Terraform AWS Infrastructure - DEVOPS-INNOVATECH

**Descripción**
Infraestructura gestionada con Terraform para desplegar una arquitectura basada en microservicios y contenedores en AWS:

* **Red Virtual (VPC)** configurada con subred pública e Internet Gateway.
* **Instancia EC2** actuando como servidor de Base de Datos (MySQL) automatizado con Docker.
* **Amazon ECR** para almacenar imágenes de contenedores del frontend (React/Vite) y backend (Spring Boot).
* **Amazon ECS (Fargate)** para la orquestación y despliegue de los servicios web.
* **Security Groups** configurados para habilitar puertos específicos (80, 8081, 8082, 3306, 22).
* **Docker Compose** para orquestación y pruebas en entornos locales.

---

### 📦 Estructura del proyecto

```text
DEVOPS-INNOVATECH/
├── back-Ventas_SpringBoot/      # Código fuente Backend (API REST)
├── front_despacho/              # Código fuente Frontend (React/Vite)
├── docker-compose.yml           # Orquestación local conectada a ECR
└── infra/etapa_2/               # Infraestructura como Código (Terraform)
    ├── compute.tf               # Instancia EC2 y User Data (MySQL)
    ├── ecr.tf                   # Repositorios elásticos de contenedores
    ├── ecs.tf                   # Clúster, Task Definitions y Servicios
    ├── iam.tf                   # Roles y políticas de acceso
    ├── main.tf                  # Configuración del provider principal
    ├── network.tf               # VPC, Subnets y Route Tables
    ├── outputs.tf               # Salidas de IPs (públicas y privadas)
    ├── provider.tf              # Dependencias de AWS
    ├── security.tf              # Grupos de seguridad y reglas de red
    ├── variables.tf             # Variables parametrizadas (región, tipo EC2)
    └── .gitignore               # Exclusión de archivos de estado (.tfstate)

🔗 Requisitos

Terraform CLI versión >= 1.0

AWS CLI configurado con credenciales de acceso.

Docker y Docker Compose instalados (para ejecución de entorno local).

Cuenta de AWS con permisos de despliegue sobre EC2, ECS, ECR y VPC.

⚙️ Flujo de uso

1. Clona el repositorio:

Bash
git clone <URL_DEL_REPOSITORIO>
cd DEVOPS-INNOVATECH/infra/etapa_2
2. Inicializa Terraform:

Bash
terraform init
3. Verifica el plan de ejecución:

Bash
terraform plan
4. Aplica los cambios en AWS:

Bash
terraform apply
5. (Opcional) Levanta el entorno local:

Bash
cd ../../
docker-compose up -d

💡 ¿Qué despliega este proyecto?
Módulo de red (network.tf): Crea una VPC (10.0.0.0/16) dedicada para el proyecto, junto con una subred pública, un Internet Gateway y una tabla de enrutamiento que permite la salida a internet.

Módulo de cómputo (compute.tf): Despliega una instancia EC2 (Amazon Linux 2023, t2.micro) que ejecuta un script de inicialización (user_data). Este script actualiza el sistema, instala Docker, y levanta automáticamente un contenedor de MySQL en el puerto 3306.

Módulo de contenedores (ecr.tf y ecs.tf): Aprovisiona tres repositorios ECR (frontend, backend ventas, backend despachos). Además, crea un clúster ECS Serverless usando AWS Fargate para ejecutar las aplicaciones, mapeando dinámicamente las variables de entorno de la base de datos hacia la IP privada de la instancia EC2.

Orquestación Local (docker-compose.yml): Un stack preparado para consumir las imágenes alojadas en AWS ECR y replicar el entorno de producción en máquinas de desarrollo de forma aislada.

📐 Diagrama de arquitectura
(Nota: Aquí puedes insertar la imagen de tu diagrama de AWS arrastrándola desde tu explorador de archivos directamente a tu editor de GitHub/GitLab)
![Diagrama AWS](./ruta-a-tu-imagen.png)

📌 Mejores prácticas incluidas
Modularización de IaC: Separación lógica de recursos por archivo (network, compute, security, ecs) para facilitar el mantenimiento.

Automatización de inicialización: Uso de user_data para evitar configuraciones manuales por SSH en el servidor de base de datos.

Gestión de secretos y estados: Archivo .gitignore configurado rigurosamente para prevenir la subida de archivos .env y el estado sensible de Terraform (.tfstate).

Dependencias de servicios: Configuración de depends_on y healthcheck en Docker Compose y Terraform para asegurar el orden correcto de inicialización de los servicios.

🔧 Cómo extender este proyecto
Implementar un Application Load Balancer (ALB) frente al clúster ECS para balancear tráfico y habilitar HTTPS.

Migrar la Base de Datos desde una instancia EC2 autogestionada hacia un servicio administrado como Amazon RDS.

Automatizar la construcción y el push de imágenes de Docker hacia ECR utilizando pipelines CI/CD mediante GitHub Actions.

Configurar un backend remoto para Terraform (como un bucket S3 y DynamoDB) para el bloqueo y gestión compartida del estado.
