# Kubernetes Learning Path

Study this before the assignment. Estimated: 6-8 hours.

---

## Day 1: Core Concepts

### 1. Architecture (45 min)
- Control plane vs worker nodes
- What's a cluster?
- kubectl basics

Read: https://kubernetes.io/docs/concepts/overview/components/

```bash
kubectl cluster-info
kubectl get nodes
```

### 2. Pods (45 min)
Smallest unit in K8s. Can have one or more containers.

Read: https://kubernetes.io/docs/concepts/workloads/pods/

```bash
kubectl run nginx --image=nginx
kubectl get pods
kubectl describe pod nginx
kubectl delete pod nginx
```

Question: What happens if this pod crashes?

### 3. Deployments (1 hour)
Manages pods. Handles self-healing, scaling, updates.

Read: https://kubernetes.io/docs/concepts/workloads/controllers/deployment/

```bash
kubectl create deployment nginx --image=nginx --replicas=3
kubectl get deployments
kubectl get pods

# Delete a pod and watch
kubectl delete pod <name>
kubectl get pods -w

kubectl scale deployment nginx --replicas=5
```

Key: Deployments automatically recreate deleted pods.

### 4. Services (1 hour)
Stable network endpoint for pods.

Types:
- ClusterIP (internal only)
- NodePort (external via node IP)
- LoadBalancer (external IP)

Read: https://kubernetes.io/docs/concepts/services-networking/service/

```bash
kubectl create deployment nginx --image=nginx
kubectl expose deployment nginx --port=80
kubectl get svc

# Test
kubectl run test --image=busybox -it --rm -- wget -qO- nginx
```

Key: Pods can reach services by name (DNS).

---

## Day 2: Configuration & Storage

### 5. ConfigMaps & Secrets (1 hour)
Store config separate from images.

- ConfigMap: non-sensitive
- Secret: sensitive (base64)

Read: https://kubernetes.io/docs/concepts/configuration/configmap/
Read: https://kubernetes.io/docs/concepts/configuration/secret/

```bash
kubectl create configmap app-config --from-literal=ENV=production
kubectl create secret generic db-secret --from-literal=password=secret123

kubectl get configmap app-config -o yaml
kubectl get secret db-secret -o yaml

# Decode
echo 'c2VjcmV0MTIz' | base64 -d
```

### 6. Persistent Volumes (1 hour)
Storage that survives pod restarts.

- PV: actual storage
- PVC: request for storage

Read: https://kubernetes.io/docs/concepts/storage/persistent-volumes/

```bash
kubectl apply -f pvc.yaml
kubectl get pvc
kubectl get pv
```

Key: Data in PVC survives pod deletion.

### 7. Health Probes (45 min)
Tell K8s if app is healthy.

- Liveness: restart if fails
- Readiness: remove from service if fails

Read: https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/

Types: HTTP, TCP, Exec

---

## Day 3: Operations

### 8. Namespaces (30 min)
Virtual clusters for isolation.

Read: https://kubernetes.io/docs/concepts/overview/working-with-objects/namespaces/

```bash
kubectl get namespaces
kubectl create namespace dev
kubectl create deployment nginx --image=nginx -n dev
```

### 9. Labels & Selectors (30 min)
Organize resources with key-value pairs.

Read: https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/

```bash
kubectl label pod nginx env=prod
kubectl get pods -l env=prod
```

### 10. Resources (45 min)
Control CPU and memory.

- Requests: guaranteed
- Limits: maximum

Read: https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/

### 11. Debugging (1 hour)

```bash
# Logs
kubectl logs <pod>
kubectl logs <pod> -f
kubectl logs <pod> --previous

# Describe
kubectl describe pod <pod>

# Execute
kubectl exec -it <pod> -- sh

# Events
kubectl get events --sort-by=.metadata.creationTimestamp

# Usage
kubectl top pods
```

Common errors:
- ImagePullBackOff: can't pull image
- CrashLoopBackOff: app keeps crashing
- Pending: can't schedule

### 12. Updates & Rollbacks (45 min)

```bash
kubectl create deployment nginx --image=nginx:1.19
kubectl set image deployment/nginx nginx=nginx:1.20
kubectl rollout status deployment/nginx
kubectl rollout history deployment/nginx
kubectl rollout undo deployment/nginx
```

---

## Practice Checklist

Before the assignment:

- [ ] Create deployment with replicas
- [ ] Expose as service
- [ ] Use ConfigMaps and Secrets
- [ ] Create PVC
- [ ] Configure health probes
- [ ] Scale deployment
- [ ] View logs and debug
- [ ] Rolling update and rollback

---

## Docker → Kubernetes

| Docker | Kubernetes |
|--------|------------|
| docker run | Deployment |
| docker ps | kubectl get pods |
| docker logs | kubectl logs |
| Container name | Service DNS |
| -p port | Service |
| volume | PVC |
| .env | ConfigMap/Secret |

---

## Resources

- https://kubernetes.io/docs/home/
- https://kubernetes.io/docs/reference/kubectl/cheatsheet/
- `kubectl explain <resource>`
- `kubectl --help`

---

Study this, then attempt the assignment.
