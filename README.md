
# gcp-helloworld

## Pré-requis

* [terraform](https://developer.hashicorp.com/terraform/downloads)
* Se connecter à GCP : `gcloud auth application-default login`
* Configurer l'utilisation d'un projet :

```bash
export PROJECT_ID=playground-s-11-5dab122a
```


## Création des machines

```bash
export TF_VAR_project_id=${PROJECT_ID}
terraform init
terraform plan
terraform apply -auto-approve
```

## Utilisation de gcloud

```bash
gcloud auth login
gcloud config set project ${PROJECT_ID}

# lister les machines
gcloud compute instances list

# se connecter en SSH à une machine
gcloud compute ssh --zone "us-west1-a" "gcpbox-01"

# mettre à jour ~/.ssh/config
gcloud compute config-ssh
gcloud compute config-ssh --remove
```

## Destruction

```bash
terraform destroy -auto-approve -var="project_id=${PROJECT_ID}"
```

## Ressources

* [How to create a VM with SSH enabled on GCP](https://binx.io/2022/01/07/how-to-create-a-vm-with-ssh-enabled-on-gcp/)


## TODO

* Générer [inventory/hosts](inventory/hosts)

