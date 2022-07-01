#!/usr/bin/env bash

[ -f ~/.kube/config ] && exit 0

server=https://kubernetes.default.svc.cluster.local
ca=$(cat /run/secrets/kubernetes.io/serviceaccount/ca.crt | base64|tr -d '\n')
token=$(cat /run/secrets/kubernetes.io/serviceaccount/token)
namespace=$(cat /run/secrets/kubernetes.io/serviceaccount/namespace)

[ -d ~/.kube ] || mkdir ~/.kube
echo "
apiVersion: v1
kind: Config
clusters:
- name: default-cluster
  cluster:
    certificate-authority-data: ${ca}
    server: ${server}
contexts:
- name: default-context
  context:
    cluster: default-cluster
    user: default-user
current-context: default-context
users:
- name: default-user
  user:
    token: ${token}
" > ~/.kube/config