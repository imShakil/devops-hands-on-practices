#!/bin/bash

# Generate private key
openssl genrsa -out bob.key 2048

# Generate certificate signing request
openssl req -new -key bob.key -out bob.csr -subj "/CN=bob/O=imshakil"

# Encode CSR to base64 (single line)
CSR_BASE64=$(cat bob.csr | base64 | tr -d '\n')

# Create the Kubernetes CSR YAML
cat > signing-request.yaml << EOF
apiVersion: certificates.k8s.io/v1
kind: CertificateSigningRequest
metadata:
  name: bob-csr
spec:
  groups:
  - system:authenticated
  request: $CSR_BASE64
  signerName: kubernetes.io/kube-apiserver-client
  usages:
  - digital signature
  - key encipherment
  - client auth
EOF

echo "Generated bob.key, bob.csr, and signing-request.yaml"