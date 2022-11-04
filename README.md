
# gce-playground

Expérimentation avec [terraform](https://www.terraform.io/) et Google Compute Engine (GCE) pour créer quelques VM jetables avec un compte [acloudguru.com](https://acloudguru.com/)

## Pré-requis

* [gcloud](https://cloud.google.com/sdk/docs/install) (`gcloud --help`)
* [terraform](https://developer.hashicorp.com/terraform/downloads) (`terraform --help`)
* Se connecter sur un compte Google Cloud :
  * Navigateur : https://console.cloud.google.com/
  * Terminal : `gcloud auth application-default login`
* Configurer l'utilisation d'un projet :

```bash
export PROJECT_ID=playground-s-11-5dab122a
```

## Principaux fichiers

* [variables.tf](variables.tf) définit les variables terraform
* [main.tf](main.tf) définit l'infrastructure dans le langage terraform
* `inventory/hosts` est généré à partir de [templates/hosts.tmpl](templates/hosts.tmpl)

## Utilisation de terraform

```bash
# Configuration des variables
export TF_VAR_project_id=${PROJECT_ID}

# Téléchargement des modules terraform
terraform init

terraform plan
# Création de l'infrastructure
terraform apply -auto-approve

# Suppression de l'infrastructure
terraform destroy -auto-approve -var="project_id=${PROJECT_ID}"
```

## Utilisation de gcloud

```bash
# Se connecter
gcloud auth login
# Variantes possibles :
# gcloud auth login --no-launch-browser

# Lister les projets
gcloud projects list

# Configurer l'utilisation d'un projet
gcloud config set project ${PROJECT_ID}

# Lister les VM
gcloud compute instances list

# se connecter en SSH à une machine
gcloud compute ssh --zone "us-west1-a" "gcebox-01"

# Configurer ~/.ssh/config pour simplifier l'accès SSH avec ansible
gcloud compute config-ssh
gcloud compute config-ssh --remove
```

## Ressources

* [How to create a VM with SSH enabled on GCP](https://binx.io/2022/01/07/how-to-create-a-vm-with-ssh-enabled-on-gcp/)

