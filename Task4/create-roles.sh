#!/bin/bash

set -e

echo "Создание namespace для продуктовой команды"
kubectl create namespace development --dry-run=client -o yaml | kubectl apply -f -

echo "Создание ролей Kubernetes"

cat <<EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: cluster-viewer
rules:
- apiGroups: [""]
  resources:
    - pods
    - services
    - configmaps
    - namespaces
    - events
  verbs:
    - get
    - list
    - watch
- apiGroups: ["apps"]
  resources:
    - deployments
    - replicasets
    - statefulsets
    - daemonsets
  verbs:
    - get
    - list
    - watch
---
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: namespace-admin
  namespace: development
rules:
- apiGroups: [""]
  resources:
    - pods
    - services
    - configmaps
    - events
  verbs:
    - get
    - list
    - watch
    - create
    - update
    - patch
    - delete
- apiGroups: ["apps"]
  resources:
    - deployments
    - replicasets
    - statefulsets
    - daemonsets
  verbs:
    - get
    - list
    - watch
    - create
    - update
    - patch
    - delete
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: security-admin
rules:
- apiGroups: [""]
  resources:
    - secrets
    - serviceaccounts
    - pods
    - services
    - configmaps
    - namespaces
    - events
  verbs:
    - get
    - list
    - watch
    - create
    - update
    - patch
    - delete
- apiGroups: ["rbac.authorization.k8s.io"]
  resources:
    - roles
    - rolebindings
    - clusterroles
    - clusterrolebindings
  verbs:
    - get
    - list
    - watch
    - create
    - update
    - patch
    - delete
- apiGroups: ["networking.k8s.io"]
  resources:
    - networkpolicies
    - ingresses
  verbs:
    - get
    - list
    - watch
    - create
    - update
    - patch
    - delete
EOF

echo "Роли созданы:"
kubectl get clusterrole cluster-viewer security-admin
kubectl get role namespace-admin -n development

# Запуск:
# chmod +x create-roles.sh
# ./create-roles.sh
