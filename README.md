# Projet DevOps - Master DSBD & IA
## Infrastructure DevOps avec CI/CD et Kubernetes

**Etudiantes** : Benmijou Maroua | Hajar Kobi  
**Etablissement** : FSBM - Universite Hassan II de Casablanca  
**Module** : Cloud & DevOps | 2026

## Description
Deploiement d'une infrastructure DevOps complete sur AWS avec :
- Application Flask API REST conteneurisee avec Docker
- Cluster Kubernetes (Master + Worker) via kubeadm
- Pipeline CI/CD automatise via GitHub Actions
- Infrastructure as Code avec Terraform et Ansible

## Structure du projet
```
devops-k8s/
├── app.py                    # Application Flask
├── Dockerfile                # Image Docker
├── requirements.txt          # Dependances Python
├── main.tf                   # Infrastructure Terraform
├── ansible/
│   ├── inventory.ini         # Inventaire Ansible
│   └── playbook.yml          # Playbook de configuration
├── k8s/
│   └── deployment.yml        # Manifests Kubernetes
└── .github/workflows/
    └── ci-cd.yml             # Pipeline CI/CD
```

## Acces a l'API
```
http://<worker_ip>:30000
http://<worker_ip>:30000/health
```

## Outils utilises
- **Cloud** : AWS (t3.micro, us-east-1)
- **IaC** : Terraform v5.0
- **Config** : Ansible v9.2.0
- **Conteneurisation** : Docker v29.3.0
- **Orchestration** : Kubernetes v1.29.15
- **CI/CD** : GitHub Actions
