#!/bin/sh

# Set your namespace
export KUBE_NAMESPACE=ns1

# Create traefik service account, role and role binding
kubectl create -f traefik-rbac.yaml

# Generate a self signed certificate 
openssl req -newkey rsa:2048 \
    -nodes \
    -keyout tls.key \
    -x509 \
    -days 365 \
    -out tls.crt \
    -subj "/C=US/ST=California/L=San Francisco/O=My Company/CN=mycompany.com"
        
# Store the cert in a secret  
kubectl create secret generic traefik-cert --namespace=${KUBE_NAMESPACE} \
    --from-file=tls.crt \
    --from-file=tls.key

# Load the traefik.toml file into a configmap
kubectl create configmap traefik-conf --from-file=traefik.toml --namespace=${KUBE_NAMESPACE}

# Create traefik service
kubectl create -f traefik-dep.yaml --namespace=${KUBE_NAMESPACE}

