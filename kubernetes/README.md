```bash
# Goviolin
kustomize edit set image ziadmmh/goviolin:v0.0.1 && kustomize build > live/live.yaml

# System
kustomize build > live/live.yaml

# Voting App
kustomize build > live/live.yaml
```