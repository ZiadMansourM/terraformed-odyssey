```bash
# Goviolin
kustomize edit set image ziadmmh/goviolin:v0.0.1 && kustomize build > live/live.yaml

# System
# Voting App
kustomize build > live/live.yaml

kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d

kubectl create secret generic argocd-notifications-secret -n argocd --from-literal slack-token=<slack-token> --dry-run=client -o yaml | kubeseal --controller-name sealed-secrets --controller-namespace sealed-secrets --format yaml > sealed-argocd-notifications-secret.yaml
```
