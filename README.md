DevOps InnovaTech - CI/CD & Infraestructura AWS
Descripción
Proyecto integral de DevOps que automatiza el aprovisionamiento de infraestructura en AWS y el despliegue de una arquitectura de microservicios. Utiliza Terraform para la infraestructura como código (IaC) y un pipeline de CI/CD en GitHub Actions para construir, almacenar y desplegar contenedores Docker en una instancia EC2.

Infraestructura como Código (IaC): Aprovisionamiento de VPC, EC2, ECR y Security Groups usando Terraform.

Microservicios: Frontend en React/Vite (servido con Nginx) y dos APIs Backend en Java Spring Boot (Ventas y Despachos).

Contenedorización: Imágenes Docker optimizadas con Multi-Stage builds para frontend y backends.

Automatización CI/CD: Pipeline de GitHub Actions que compila, sube imágenes a Amazon ECR y despliega automáticamente usando Docker Compose vía SSH.

Gestión de Base de Datos: Contenedor MySQL versión 8 con volúmenes persistentes y healthchecks.

📦 Estructura del proyecto
Plaintext
DEVOPS-INNOVATECH/
├── .github/
│   └── workflows/
│       └── cicd.yml                # Pipeline automatizado de CI/CD
├── back-Despachos_SpringBoot/      # Microservicio de Despachos
│   ├── src/
│   ├── pom.xml
│   └── Dockerfile                  # Multi-stage build (Java 17)
├── back-Ventas_SpringBoot/         # Microservicio de Ventas
│   ├── src/
│   ├── pom.xml
│   └── Dockerfile                  # Multi-stage build (Java 17)
├── front_despacho/                 # Aplicación Frontend (Node/Vite)
│   ├── src/
│   ├── package.json
│   ├── nginx.conf
│   └── Dockerfile                  # Multi-stage build (Node 18 -> Nginx)
├── infra/etapa_2/                  # Código de Infraestructura (Terraform)
│   ├── compute.tf                  # Definición de instancia EC2
│   ├── network.tf                  # VPC, Subnets y ruteo
│   ├── ecr.tf                      # Repositorios de contenedores
│   ├── security.tf                 # Grupos de seguridad
│   ├── main.tf
│   └── variables.tf
└── docker-compose.yml              # Orquestación de contenedores en el servidor
🚀 Requisitos
Terraform CLI instalado localmente.

Cuenta de AWS con credenciales de acceso (Access Key ID y Secret Access Key).

GitHub Repository con los siguientes Secrets configurados para el entorno:

AWS_ACCESS_KEY_ID y AWS_SECRET_ACCESS_KEY

AWS_SESSION_TOKEN (Si aplica)

EC2_SSH_KEY (Llave privada PEM para acceder a la instancia)

Docker y Docker Compose (para pruebas en entornos locales).

⚙️ Flujo de uso y despliegue
1. Aprovisionar la Infraestructura (Terraform)
Primero, debes crear los recursos en AWS. Navega a la carpeta de infraestructura e inicializa Terraform:

Bash
cd infra/etapa_2
terraform init
Verifica el plan de ejecución y aplícalo:

Bash
terraform plan
terraform apply -auto-approve
(Nota: Guarda la IP pública de la instancia EC2 generada y actualízala en tu archivo cicd.yml en la variable EC2_HOST).

2. Despliegue automatizado (CI/CD)
El proyecto cuenta con integración y entrega continua. Para desplegar la aplicación, simplemente realiza un push a la rama deploy:

Bash
git add .
git commit -m "feat: actualización de servicios"
git push origin deploy
El pipeline de GitHub Actions se encargará de compilar, empaquetar, subir las imágenes a Amazon ECR y reiniciar los contenedores en la máquina EC2 de forma automática.

🏗️ ¿Qué despliega este proyecto? (Paso a paso)
El proyecto funciona en dos grandes etapas operativas:

1. Infraestructura Base (Terraform):
Se encarga de crear el ecosistema de red (VPC, Subnets), las reglas de seguridad (Security Groups para habilitar los puertos 80, 8081, 8082, 3306 y 22), los repositorios privados en Amazon ECR para almacenar las imágenes Docker, y finalmente una máquina virtual Amazon EC2 (Ubuntu/Amazon Linux) que actuará como servidor host.

2. Despliegue de Aplicación (GitHub Actions + Docker Compose):
Cuando se detectan cambios, el workflow cicd.yml ejecuta lo siguiente:

Build & Push: Lee los Dockerfile de cada carpeta. Usa Maven para compilar los .jar de Spring Boot y Node para compilar los estáticos del Frontend. Luego, crea imágenes mínimas basadas en Alpine/Nginx y las sube a los repositorios de Amazon ECR.

Transferencia: Copia el archivo docker-compose.yml desde el repositorio hacia la instancia EC2 usando SCP.

Despliegue unificado: Se conecta por SSH a la EC2, inyecta las variables de entorno de base de datos dinámicamente (.env), se autentica con Amazon ECR, descarga (pull) las imágenes más recientes y levanta los servicios (docker compose up -d).

Servicios levantados en el EC2:

Frontend: Expuesto en el puerto 80.

Backend Ventas: Expuesto en el puerto 8081.

Backend Despachos: Expuesto en el puerto 8082.

Base de datos: MySQL 8 expuesto en el puerto 3306, aislado en su propia red interna y con almacenamiento persistente.

📐 Diagrama de arquitectura
(Aquí puedes insertar la imagen de tu diagrama de red y componentes, mostrando la VPC, las Subnets públicas, la EC2 con los contenedores Docker dentro, y los repositorios ECR conectados).

📌 Mejores prácticas incluidas
Multi-stage Builds en Docker: Se utilizan etapas de "builder" para compilar el código (Maven/Node) y luego imágenes base ligeras (Alpine/Nginx/JRE) solo para la ejecución, reduciendo drásticamente el tamaño final de las imágenes y mejorando la seguridad.

Principio de mínimo privilegio: En los Dockerfile de Spring Boot, se crea y utiliza un usuario no-root (spring) para ejecutar la aplicación, evitando vulnerabilidades si el contenedor es comprometido.

Aislamiento de Redes: En el docker-compose.yml, los servicios están segmentados en redes lógicas (frontend-net y backend-net), evitando que el frontend tenga comunicación directa e innecesaria con la base de datos.

Healthchecks: El contenedor MySQL incluye un healthcheck nativo, y los backends tienen una condición depends_on: service_healthy para asegurar que la aplicación no inicie hasta que la base de datos esté 100% operativa.

Infraestructura Modular: Separación clara del código de infraestructura en archivos .tf específicos según su propósito (red, cómputo, seguridad, IAM).

🛠️ Cómo extender este proyecto
Implementar Balanceo de Carga: Agregar un Application Load Balancer (ALB) delante de las instancias EC2 para manejar el tráfico de forma más eficiente y permitir escalabilidad horizontal (Auto Scaling Groups).

Migrar a Base de Datos Administrada: Reemplazar el contenedor MySQL por una instancia de Amazon RDS para obtener respaldos automáticos, alta disponibilidad y mejor rendimiento.

Orquestación Avanzada: Migrar el docker-compose en una única EC2 hacia un clúster de Amazon ECS (Elastic Container Service) o EKS (Kubernetes) para despliegues empresariales.

Certificados SSL: Integrar AWS Certificate Manager (ACM) en el Load Balancer o configurar Certbot (Let's Encrypt) en Nginx para habilitar tráfico HTTPS en el Frontend y las APIs.