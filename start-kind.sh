#!/bin/bash

kind create cluster --config=cluster-2+4.yaml

# Kind specific patches to forward the hostPorts to the ingress controller, 
# set taint tolerations and schedule it to the custom labelled node.
# Command is copied from https://kind.sigs.k8s.io/docs/user/ingress/
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml

# Wait until ready to process requests.
# Command is copied from https://kind.sigs.k8s.io/docs/user/ingress/
kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=120s
