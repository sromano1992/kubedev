#!/bin/bash
#set -x
cd src
cat deployment.yaml

echo "KUBERNETES COMMAND: (WARNING!! temporally the default Kubernetes namespace will be used because the registry is not accessible from the other namespaces)"
echo "kubectl apply -f deployment.yaml"

#deploy
kubectl apply -f deployment.yaml
echo "end"



