#!/bin/bash

set -e

echo "Создание RoleBinding и ClusterRoleBinding"

cat <<EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: cluster-viewer-binding
subjects:
- kind: User
  name: cluster-viewer
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: ClusterRole
  name: cluster-viewer
  apiGroup: rbac.authorization.k8s.io
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: namespace-admin-binding
  namespace: development
subjects:
- kind: User
  name: namespace-admin
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: Role
  name: namespace-admin
  apiGroup: rbac.authorization.k8s.io
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: security-admin-binding
subjects:
- kind: User
  name: security-admin
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: ClusterRole
  name: security-admin
  apiGroup: rbac.authorization.k8s.io
EOF

echo "Привязки созданы:"
kubectl get clusterrolebinding cluster-viewer-binding security-admin-binding
kubectl get rolebinding namespace-admin-binding -n development

# Запуск:
# chmod +x create-bindings.sh
# ./create-bindings.sh
