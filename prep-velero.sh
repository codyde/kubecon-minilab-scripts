#!/bin/bash
# Intent of lab is to demo Velero backup capabilities. Script will install awscli, metallb and then deploy minio without a pvc to the kubernetes cluster. 
wget https://gist.githubusercontent.com/codyde/5cc4eea515dba6970ef7e39848b73042/raw/e925ca9ec0d623572c1aa768cc0287f904f87b0a/envoy-update.yaml
wget https://raw.githubusercontent.com/codyde/kubecon-contour-lab/master/contour-final-state.yaml
wget https://gist.githubusercontent.com/codyde/fc61f8dd77830e67db3a72feea628216/raw/1d5d522652bd96fa2cd94f13da1236298e92bdfb/minio-service.yaml
/usr/local/bin/k8s-start
kubectl apply -f https://projectcontour.io/quickstart/contour.yaml
export externalip=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)
export externalfqdn=$(curl -s http://169.254.169.254/latest/meta-data/public-hostname)
sed -i 's/REPLACEME/'"$externalip"'/g' envoy-update.yaml
kubectl apply -f envoy-update.yaml --force
kubectl apply -f https://raw.githubusercontent.com/codyde/kubecon-contour-lab/master/pods-and-services.yaml
sed -i 's/REPLACEME/'"$externalfqdn"'/g' contour-final-state.yaml
kubectl apply -f contour-final-state.yaml
kubectl apply -f https://gist.githubusercontent.com/codyde/222ad38e6331181aac41ef7df643d6bd/raw/b322be100ecd3b32f23efe6a5dca0e5081e911a2/minio-nopvc.yaml
sed -i 's/REPLACEME/'"$externalip"'/g' minio-service.yaml
kubectl apply -f minio-service.yaml
sudo apt install -y awscli

