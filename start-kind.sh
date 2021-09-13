#!/bin/bash

kind create cluster --config=cluster-2+4.yaml

# Kind specific patches to forward the hostPorts to the ingress controller, 
# set taint tolerations and schedule it to the custom labelled node.
# Command is copied from https://kind.sigs.k8s.io/docs/user/ingress/
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml

# The same command as above, but using helm instead of just kubectl. This is not working since
# it doesn't apply the kind specific patches applied by the command above. It should however
# work fine in a 'real' (not kind) cluster.
# helm install ingress-nginx ingress-nginx/ingress-nginx

# Wait until ready to process requests.
# Command is copied from https://kind.sigs.k8s.io/docs/user/ingress/
# Note that when using the helm command above, namespace must be changed to default.
kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=120s
