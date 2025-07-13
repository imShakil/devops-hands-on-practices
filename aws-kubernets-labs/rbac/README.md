# Role Based Access Control In Kubernetes

- create a kubernetes namespace

```sh
kubectl create ns lfs158
```

- create directory

```sh
mkdir -p rbac
```

- create user and pass

```sh
sudo useradd -s /bin/bash bob
sudo passwd bob
```

- create private key

```sh
openssl genrsa -out bob.key 2048
openssl req -new -key bob.key -oiut bob.csr -subj "/CN=bob/O=learner"
```

- copy csr into clipboard

```sh
cat bob.csr | base64 | tr -d '\n'
```

- create a certificate signing request object with this [config](./signing-request.yaml)

```sh
kubectl create -f signing-request.yaml
```

- check csr

```sh
kubectl get csr
```

```output
imshakil@myserver:~/rbac$ kubectl get csr
NAME        AGE    SIGNERNAME                                    REQUESTOR              REQUESTEDDURATION   CONDITION
bob-csr     80s    kubernetes.io/kube-apiserver-client           minikube-user          <none>              Pending
csr-nf4n4   103m   kubernetes.io/kube-apiserver-client-kubelet   system:node:minikube   <none>              Approved,Issued
```

- approve csr

```sh
kubectl certificate approve bob-csr
```

```output
imshakil@myserver:~/rbac$ kubectl get csr
NAME        AGE    SIGNERNAME                                    REQUESTOR              REQUESTEDDURATION   CONDITION
bob-csr     2m1s   kubernetes.io/kube-apiserver-client           minikube-user          <none>              Approved,Issued
csr-nf4n4   103m   kubernetes.io/kube-apiserver-client-kubelet   system:node:minikube   <none>              Approved,Issued
```

- Extract the approved certificate from the certificate signing request, decode it with base64 and save it as a certificate file. Then view the certificate in the newly created certificate file:

```sh
kubectl get csr bob-csr -o json
```

```json
kubectl get csr bob-csr -o json
{
    "apiVersion": "certificates.k8s.io/v1",
    "kind": "CertificateSigningRequest",
    "metadata": {
        "creationTimestamp": "2025-07-12T14:38:51Z",
        "name": "bob-csr",
        "resourceVersion": "5397",
        "uid": "7f5dd931-7040-462e-983a-5e3dbfe7f37f"
    },
    "spec": {
        "extra": {
            "authentication.kubernetes.io/credential-id": [
                "X509SHA256=ef741b894cae06aa6a557b1ec602673ab93c1819a6c6316a4da247daac21256f"
            ]
        },
        "groups": [
            "system:masters",
            "system:authenticated"
        ],
        "request": "LS0tLS1CRUdJTiBDRVJUSUZJQ0FURSBSRVFVRVNULS0tLS0KTUlJQ1pqQ0NBVTRDQVFBd0lURU1NQW9HQTFVRUF3d0RZbTlpTVJFd0R3WURWUVFLREFocGJYTm9ZV3RwYkRDQwpBU0l3RFFZSktvWklodmNOQVFFQkJRQURnZ0VQQURDQ0FRb0NnZ0VCQU90Ym1Rejcydmt0T2FvYk1KM3RsWkRqClRTT2thd2psUk54b0NXMVI1R1pId24xZS9hK3N3ZVhKeFlXQm53Q0x2U3VHZ2kxNnNUdWNPUlMxSVltQ1o4OEYKcFVCSmU0SGVIT2dJZXk2NDM0REpyUmpEczd3Z3dFZXd4b1ltRWNXam5ZZWVsMytQdVZpRk1QRjJSTEltZ2VPTgpCb2d2RDBNOGpKL2JVUHdkK01YcnlSN1hZZGNuaFJoQTliL1lRRjVqVGViaE95VXdmLzY2c2xxRVhGSjB1bk90Cno4VHpWeUVkM3lOZXN1WGVOU0oyb0dQM052VUlvRXZOQzRwYnFLdGhYREZrYThYejhHOElIdk1USithc1JmUmgKU2U4bllscERacUlra3c5NnR1WnlQNE5KSm84azRYdmRyWTRVSHowMmozeFdIWG85VkJNcU5ZN1NOWk1hRzdzQwpBd0VBQWFBQU1BMEdDU3FHU0liM0RRRUJDd1VBQTRJQkFRQ21sMFdZTmcxdTA5VkVsRlVITkU3UGgvQm5ES2ZxCjFFM3BXZEx1UHRMOGVSVExPRmRGRTlZdWd1a293YlpwaDl5S0NsMkMwYzE1bHU1VysvMWpHaHI4M1VGUkh0R3oKQlNEeXRxckxwSCtvb1dkVWRyTk5BVkJUZm5yTTdoOWhZU2RUNytmekJORWNYa0xjcmlETGl2K3FtaEhTQk1QVQo1ZndCKzZyS05uRHdRTUxPWkZSTG5LNFQrTmFPQmZnbEMzUmc1bU13QXptMlQ4VHplWnVVNUtwc2w2eWJXdDNhClF6MU0rcW1qemVJT2RGK1NHZk4yU3MzT3Y4RG5tQ3lON3VQUHFzYVYxNXFIeThzbHhuTDZWOWFtWWZKall2cTkKQTBWTTNzUnhlYkl5WXFrM01XclJGN2NFeG13KzZBMEZPb1hiWnlITms4NG1CSElnTGtpcTZtaDQKLS0tLS1FTkQgQ0VSVElGSUNBVEUgUkVRVUVTVC0tLS0tCg==",
        "signerName": "kubernetes.io/kube-apiserver-client",
        "usages": [
            "digital signature",
            "key encipherment",
            "client auth"
        ],
        "username": "minikube-user"
    },
    "status": {
        "certificate": "LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSURGakNDQWY2Z0F3SUJBZ0lRWU51WkhkclRNNkJSempUam9SdXdFekFOQmdrcWhraUc5dzBCQVFzRkFEQVYKTVJNd0VRWURWUVFERXdwdGFXNXBhM1ZpWlVOQk1CNFhEVEkxTURjeE1qRTBNelUwT0ZvWERUSTJNRGN4TWpFMApNelUwT0Zvd0lURVJNQThHQTFVRUNoTUlhVzF6YUdGcmFXd3hEREFLQmdOVkJBTVRBMkp2WWpDQ0FTSXdEUVlKCktvWklodmNOQVFFQkJRQURnZ0VQQURDQ0FRb0NnZ0VCQU90Ym1Rejcydmt0T2FvYk1KM3RsWkRqVFNPa2F3amwKUk54b0NXMVI1R1pId24xZS9hK3N3ZVhKeFlXQm53Q0x2U3VHZ2kxNnNUdWNPUlMxSVltQ1o4OEZwVUJKZTRIZQpIT2dJZXk2NDM0REpyUmpEczd3Z3dFZXd4b1ltRWNXam5ZZWVsMytQdVZpRk1QRjJSTEltZ2VPTkJvZ3ZEME04CmpKL2JVUHdkK01YcnlSN1hZZGNuaFJoQTliL1lRRjVqVGViaE95VXdmLzY2c2xxRVhGSjB1bk90ejhUelZ5RWQKM3lOZXN1WGVOU0oyb0dQM052VUlvRXZOQzRwYnFLdGhYREZrYThYejhHOElIdk1USithc1JmUmhTZThuWWxwRApacUlra3c5NnR1WnlQNE5KSm84azRYdmRyWTRVSHowMmozeFdIWG85VkJNcU5ZN1NOWk1hRzdzQ0F3RUFBYU5XCk1GUXdEZ1lEVlIwUEFRSC9CQVFEQWdXZ01CTUdBMVVkSlFRTU1Bb0dDQ3NHQVFVRkJ3TUNNQXdHQTFVZEV3RUIKL3dRQ01BQXdId1lEVlIwakJCZ3dGb0FVdzdjWXRzdHhlMkRZd0JIaS9hdDdBeUpleTZBd0RRWUpLb1pJaHZjTgpBUUVMQlFBRGdnRUJBSkdjM1gyaVFHRDZySnVTN1JkOTJzcHZhQW5ocnlGVEZ6MWZaSUNyVHgwNGNNYzBWRTg1ClNDUURVS05MMEJWUG1OOXNhL29QWkE1QnUzcGcvSWR6M1J2M1lQSFpaUTAwVTRpKzFKWGRkRis1RUpCK2Ewbm0KR3ZITlZ0dXRZczRJQkNIL1RUWmxtREN1ellIVGpKRnVISWY3RzBiNjVRb1VaR3NvaThzWGRVMStJMkdva1NFTQoySlllZDUvSjBrVnRucEliSXJRRmhXb00wT1FYcTBpMmRYVUNCUUhLckplOHM5d2NPNFNyV3hpamtRQVJHZnJUCmNaZWlhMWh1RHMzNGdVL2tOMkw5cE0rM1Y3K0ptc0d5cVpTMmZpSTJiajN0eDJteTFlY2J6aWZkazlKWVdsWlUKNEUrelRod2pxaXRCNUJ0UXlQS1RUSlNPbUZYc2RuNUlmOGs9Ci0tLS0tRU5EIENFUlRJRklDQVRFLS0tLS0K",
        "conditions": [
            {
                "lastTransitionTime": "2025-07-12T14:40:48Z",
                "lastUpdateTime": "2025-07-12T14:40:48Z",
                "message": "This CSR was approved by kubectl certificate approve.",
                "reason": "KubectlApprove",
                "status": "True",
                "type": "Approved"
            }
        ]
    }
}
```

to extract certificate, we can use `jq`:

```sh
kubectl get csr bob-csr -o json | jq -r .status.certificate
```

and to save the certificate:

```sh
kubectl get csr bob-csr -o json | jq -r .status.certificate | bas64 -d > bob.crt
```

- Configure the kubectl client's configuration manifest with user bob's credentials by assigning his key and certificate:

```sh
kubectl config set-credentials bob --client-certificate=bob.crt --client-key=bob.key
```

- Create a new context entry in the kubectl client's configuration manifest for user bob, associated with the lfs158 namespace in the minikube cluster:

```sh
kubectl config set-context bob-context --cluster=minikube --namespace=lfs158 --user=bob
```

- Lets verify update kubectl config:

```sh
kubectl config view -o json
```

```json
{
    "kind": "Config",
    "apiVersion": "v1",
    "preferences": {},
    "clusters": [
        {
            "name": "minikube",
            "cluster": {
                "server": "https://192.168.49.2:8443",
                "certificate-authority": "/home/imshakil/.minikube/ca.crt",
                "extensions": [
                    {
                        "name": "cluster_info",
                        "extension": {
                            "last-update": "Sat, 12 Jul 2025 12:57:08 UTC",
                            "provider": "minikube.sigs.k8s.io",
                            "version": "v1.36.0"
                        }
                    }
                ]
            }
        }
    ],
    "users": [
        {
            "name": "bob",
            "user": {
                "client-certificate": "/home/imshakil/rbac/bob.crt",
                "client-key": "/home/imshakil/rbac/bob.key"
            }
        },
        {
            "name": "minikube",
            "user": {
                "client-certificate": "/home/imshakil/.minikube/profiles/minikube/client.crt",
                "client-key": "/home/imshakil/.minikube/profiles/minikube/client.key"
            }
        }
    ],
    "contexts": [
        {
            "name": "bob-context",
            "context": {
                "cluster": "minikube",
                "user": "bob",
                "namespace": "lsf158"
            }
        },
        {
            "name": "minikube",
            "context": {
                "cluster": "minikube",
                "user": "minikube",
                "namespace": "default",
                "extensions": [
                    {
                        "name": "context_info",
                        "extension": {
                            "last-update": "Sat, 12 Jul 2025 12:57:08 UTC",
                            "provider": "minikube.sigs.k8s.io",
                            "version": "v1.36.0"
                        }
                    }
                ]
            }
        }
    ],
    "current-context": "minikube"
}
```

- lets create a new deployment in `lfs158` namespace:

```sh
kubectl create deployment nginx --image=nginx:latest -n lfs158
```

- From the new context bob-context try to list pods. The attempt fails because user bob has no permissions configured for the bob-context:

```sh
kubectl --context=bob-context get pods
```

> This must return a permission issue

- This [config](./role.yaml) will assign a limited set of permissions to user bob in the bob-context, lets assign a role for user bob in bob-context:

```sh
kubectl create -f role.yaml
```

- Create a [YAML configuration manifest](./rolebinding.yaml) for a rolebinding object, which assigns the permissions of the pod-reader Role to user bob. Then create the rolebinding object and list it from the default minikube context, but from the lfs158 namespace:

```sh
kubectl create -f rolebinding.yaml
```

- lets check role and rolebinding:

```sh
kubectl get roles -n lfs158
kubectl get rolebindings -n lfs158
```

- Now that we have assigned permissions to bob, we can successfully list pods from the new context bob-context.

```sh
kubectl get pods --context=bob-context
```

> It should return pods status now
