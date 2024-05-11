```bash
echo "testing321" | htpasswd -i -c ./secrets/auth-ignore-local-secret ziadh

# First Example
kubectl create secret generic goviolin-ingress-secret -n goviolin --from-file auth-ignore-local-secret --dry-run=client -o yaml > goviolin-ingress-secret-ignore.yaml

kubeseal --controller-name sealed-secrets --controller-namespace sealed-secrets --format yaml < secrets/goviolin-ingress-secret-ignore.yaml > sealed-goviolin-ingress-secret.yaml

# Second Example
kubectl create secret generic argocd-notifications-secret -n argocd --from-file  --dry-run=client -o yaml > secrets/argocd-notifications-secret.yaml

# read secrets/argocd-notifications-secret.yaml then seal it:
kubeseal --controller-name sealed-secrets --controller-namespace sealed-secrets --format yaml < secrets/argocd-notifications-secret.yaml > sealed-argocd-notifications-secret.yaml
```


```bash
# Goviolin
kustomize edit set image ziadmmh/goviolin:v0.0.1 && kustomize build > live/live.yaml

# System
# Voting App
kustomize build > live/live.yaml

kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d

kubectl create secret generic argocd-notifications-secret -n argocd --from-literal slack-token=<slack-token> --dry-run=client -o yaml | kubeseal --controller-name sealed-secrets --controller-namespace sealed-secrets --format yaml > sealed-argocd-notifications-secret.yaml
```
