#!/bin/bash

export host_ip=$(curl -s ifconfig.io)

sudo apt update -y
sudo apt install -y curl

export INSTALL_K3S_EXEC="--disable=traefik --tls-san=$host_ip"
curl -sfL https://get.k3s.io | sh -

sudo chmod 644 /etc/rancher/k3s/k3s.yml

# Optionnel : afficher le status de k3s
sudo systemctl status k3s

# Note : L'export KUBECONFIG ici ne sera valide que pour le script
# Si tu veux l'utiliser après, tu dois exporter dans ta session manuelle

echo "K3s installé avec succès, kubeconfig disponible dans /etc/rancher/k3s/k3s.yml"
