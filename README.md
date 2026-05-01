# 🏗️ PecheTech Infrastructure Repository

Bienvenue dans le dépôt centralisé de **l'Infrastructure as Code (IaC)** du projet PecheTech.
Ce dépôt contient toutes les configurations nécessaires pour déployer l'écosystème PecheTech (Microservices, bases de données, brokers de messages, pipelines IA) de manière reproductible, tant en environnement local de développement qu'en production sur des clusters Kubernetes.

---

## 📑 Sommaire
1. [Architecture Globale](#architecture-globale)
2. [Structure du Dépôt](#structure-du-dépôt)
3. [Prérequis](#prérequis)
4. [Démarrage Rapide (Environnement Local)](#démarrage-rapide-environnement-local)
5. [Déploiement Cloud & Kubernetes](#déploiement-cloud--kubernetes)
6. [Standards d'Industrialisation](#standards-dindustrialisation)

---

## 🏛 Architecture Globale
L'infrastructure de PecheTech repose sur une architecture Cloud-Native orientée microservices :
- **Réseau / Gateway** : Traefik (Local) / NGINX Ingress Controller (Production).
- **Bases de Données** : PostgreSQL avec l'extension **PostGIS** (indispensable pour les requêtes spatiales du module IA/Météo).
- **Cache & Messages** : Redis et RabbitMQ (pour la communication asynchrone entre services).
- **Conteneurisation** : Docker & Docker Compose.
- **Orchestration** : Kubernetes (K8s) provisionné via Terraform.

---

## 📂 Structure du Dépôt

\`\`\`text
pechetech-infrastructure/
├── docker/
│   └── docker-compose.yml       # Configuration unifiée pour lancer tous les services en local
├── kubernetes/
│   ├── base/                    # Manifests K8s standards (Deployments, Services, ConfigMaps)
│   └── overlays/                # Spécificités par environnement (dev, staging, prod)
├── terraform/
│   ├── modules/                 # Modules réutilisables (VPC, EKS/GKE, RDS)
│   └── environments/            # Fichiers .tfvars par environnement
├── scripts/
│   ├── setup_env.sh             # Scripts utilitaires d'amorçage
│   └── deploy.sh                # Script de déploiement CI/CD
└── docs/                        # Diagrammes d'architecture (MCD, MLOps, Réseau)
\`\`\`

---

## 🛠 Prérequis
Avant de démarrer, assurez-vous d'avoir installé les outils suivants sur votre machine :
- [Docker](https://docs.docker.com/get-docker/) et [Docker Compose](https://docs.docker.com/compose/install/)
- [Terraform](https://developer.hashicorp.com/terraform/downloads) (>= 1.5.0)
- [Kubectl](https://kubernetes.io/docs/tasks/tools/)
- Un client Git

---

## 🚀 Démarrage Rapide (Environnement Local)

L'environnement local est géré par **Docker Compose**. Il va instancier une base de données PostGIS, Redis, RabbitMQ, un API Gateway Traefik, ainsi que tous les microservices locaux (qu'il va "builder" à la volée depuis leurs dossiers respectifs).

### 1. Cloner tous les dépôts
Assurez-vous que tous les dépôts `pechetech-*` sont situés dans le même dossier parent.
\`\`\`bash
# Arborescence attendue :
# /Mg4TechPechetech
#  ├── pechetech-benefit-service
#  ├── pechetech-finance-ocr-service
#  ├── pechetech-fuel-service
#  ├── pechetech-predictive-weather-service
#  └── pechetech-infrastructure
\`\`\`

### 2. Lancer la stack locale
Placez-vous dans le dossier `docker` de ce dépôt et lancez la commande suivante :
\`\`\`bash
cd pechetech-infrastructure/docker
docker-compose up --build -d
\`\`\`

### 3. Vérifier les services
Traefik expose automatiquement les routes. Vous pouvez vérifier l'état des services :
- **Traefik Dashboard** : [http://localhost:8080](http://localhost:8080)
- **Benefit Service** : [http://localhost/api/v1/expenses/health](http://localhost/api/v1/expenses/health) (si implémenté)
- **Predictive Weather** : [http://localhost/api/v1/predictions/zones/today](http://localhost/api/v1/predictions/zones/today)

---

## ☁️ Déploiement Cloud & Kubernetes

Le déploiement en environnement cible (ex: Sénégal Numérique SA ou AWS) suit l'approche **GitOps**.

1. **Provisionnement des ressources Cloud (Terraform)** :
   \`\`\`bash
   cd terraform/environments/prod
   terraform init
   terraform apply
   \`\`\`
   *Ceci créera le cluster Kubernetes managé, le VPC et les bases de données gérées (RDS).*

2. **Déploiement des microservices (Kustomize/Kubectl)** :
   \`\`\`bash
   kubectl apply -k kubernetes/overlays/prod
   \`\`\`

---

## 🛡 Standards d'Industrialisation
- **Sécurité** : Les secrets (Mots de passe DB, Clés API) ne sont jamais commités. Utilisez des `.env` locaux ou un gestionnaire de secrets (Hashicorp Vault / AWS Secrets Manager) en production.
- **Réseau** : Les bases de données ne sont **jamais exposées** publiquement. Seul le Gateway (Traefik/Ingress) est accessible de l'extérieur.
- **Healthchecks** : Chaque microservice doit exposer une route `/health` (ou `/api/v1/.../health`) surveillée par K8s (Liveness/Readiness probes).
