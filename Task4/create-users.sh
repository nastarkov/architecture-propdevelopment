#!/bin/bash

set -e

CERT_DIR="./certs"
mkdir -p "$CERT_DIR"

echo "Создание ключей и CSR для пользователей Kubernetes"

openssl genrsa -out "$CERT_DIR/cluster-viewer.key" 2048

openssl req -new \
  -key "$CERT_DIR/cluster-viewer.key" \
  -out "$CERT_DIR/cluster-viewer.csr" \
  -subj "/CN=cluster-viewer/O=cluster-viewers"

openssl genrsa -out "$CERT_DIR/namespace-admin.key" 2048

openssl req -new \
  -key "$CERT_DIR/namespace-admin.key" \
  -out "$CERT_DIR/namespace-admin.csr" \
  -subj "/CN=namespace-admin/O=namespace-admins"

openssl genrsa -out "$CERT_DIR/security-admin.key" 2048

openssl req -new \
  -key "$CERT_DIR/security-admin.key" \
  -out "$CERT_DIR/security-admin.csr" \
  -subj "/CN=security-admin/O=security-admins"

echo "Подписание сертификатов через CA Minikube"

openssl x509 -req \
  -in "$CERT_DIR/cluster-viewer.csr" \
  -CA ~/.minikube/ca.crt \
  -CAkey ~/.minikube/ca.key \
  -CAcreateserial \
  -out "$CERT_DIR/cluster-viewer.crt" \
  -days 365

openssl x509 -req \
  -in "$CERT_DIR/namespace-admin.csr" \
  -CA ~/.minikube/ca.crt \
  -CAkey ~/.minikube/ca.key \
  -CAcreateserial \
  -out "$CERT_DIR/namespace-admin.crt" \
  -days 365

openssl x509 -req \
  -in "$CERT_DIR/security-admin.csr" \
  -CA ~/.minikube/ca.crt \
  -CAkey ~/.minikube/ca.key \
  -CAcreateserial \
  -out "$CERT_DIR/security-admin.crt" \
  -days 365

echo "Пользователи созданы:"
echo "- cluster-viewer"
echo "- namespace-admin"
echo "- security-admin"

# Запуск: 
# chmod +x create-users.sh
# ./create-users.sh