# Kubernetes Assignment

Deploy CampusFit to Kubernetes.

---

## Prerequisites

- Docker assignment complete
- kubectl installed
- Minikube OR k3s (choose one)
- Image on Docker Hub

---

## Setup

### Minikube
```bash
minikube start
kubectl get nodes
```

### k3s
```bash
curl -sfL https://get.k3s.io | sh -
mkdir -p ~/.kube
sudo cp /etc/rancher/k3s/k3s.yaml ~/.kube/config
sudo chown $USER ~/.kube/config
kubectl get nodes
```

---

## Part 1: MongoDB (60 min)

Create in `k8s/` directory:

### 1.1 Secret
`mongodb-secret.yaml` - MongoDB credentials

Research: How to base64 encode?

### 1.2 PersistentVolumeClaim  
`mongodb-pvc.yaml` - 1Gi storage

### 1.3 Deployment
`mongodb-deployment.yaml`
- mongo:7 image
- 1 replica
- Use secret for credentials
- Mount PVC

### 1.4 Service
`mongodb-service.yaml`
- Port 27017
- Internal only

```bash
kubectl apply -f k8s/
kubectl get pods
kubectl get pvc
```

---

## Part 2: App (60 min)

### 2.1 ConfigMap
`app-configmap.yaml` - PORT, APP_ENV

### 2.2 Deployment
`app-deployment.yaml`
- Your Docker Hub image
- 2 replicas minimum
- Health probes on /health
- MONGO_URI using service name

Question: What should the service name be in the connection string?

### 2.3 Service
`app-service.yaml`
- Minikube: LoadBalancer
- k3s: NodePort

```bash
kubectl apply -f k8s/

# Access
minikube service <name> --url  # minikube
kubectl get svc  # k3s, use node IP + port
```

Test:
```bash
curl <URL>/health
curl -X POST <URL>/student -H "Content-Type: application/json" -d '{"name":"Test","membership":"Premium"}'
```

---

## Part 3: Operations (45 min)

### 3.1 Scale
Scale to 3 replicas.

### 3.2 Update
Change APP_ENV to "production" and apply.

### 3.3 Rollback
Practice rolling back.

### 3.4 Self-healing
Delete one pod. What happens?

---

## Part 4: Persistence Test (30 min)

1. Register students
2. Delete MongoDB pod
3. Check if data survived

Why or why not?

---

## Part 5: Debug (30 min)

Practice:
```bash
kubectl logs <pod>
kubectl describe pod <pod>
kubectl exec -it <pod> -- sh
kubectl get events
```

Break something intentionally, then fix it.

---

## Advanced (Optional)

### Namespaces
Deploy to custom namespace.

### Resource Limits
Add CPU/memory limits.

### HPA
Auto-scale based on CPU.

### StatefulSet
Should MongoDB use StatefulSet? Why?

---

## Submission

Files:
- All YAML in `k8s/`

Screenshots:
- `kubectl get all`
- Working endpoints

Document (500 words):
- K8s vs Docker networking
- How PVC works
- Scaling behavior
- Challenges faced

---

## Grading

| Item | Points |
|------|--------|
| MongoDB with persistence | 20 |
| App with 2+ replicas | 20 |
| External access | 15 |
| Health probes | 10 |
| Scaling | 10 |
| ConfigMap/Secret | 10 |
| Documentation | 15 |
| Total | 100 |

Bonus: +5 each for namespace, resources, HPA, ingress

---

## Common Issues

- ImagePullBackOff: wrong image name
- CrashLoopBackOff: check logs, usually MongoDB connection
- Pending PVC: check storage class
- Service not accessible: minikube needs `minikube service`, k3s needs node IP

---

Time: 3-4 hours
