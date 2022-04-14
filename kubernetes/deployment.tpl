apiVersion: apps/v1
kind: Deployment
metadata:
  name: analytical-platform-external-tools
spec:
  replicas: 3
  selector:
    matchLabels:
      app: gin
  template:
    metadata:
      labels:
        app: gin
    spec:
      containers:
      - name: gin
        image: 754256621582.dkr.ecr.eu-west-2.amazonaws.com/${ECR_NAME}:${IMAGE_TAG}
        ports:
        - containerPort: 8080
---
apiVersion: v1
kind: Service
metadata:
  name: analytical-platform-external-tool
  labels:
    app: gin
spec:
  ports:
  - port: 8080
    name: http
    targetPort: 8080
  selector:
    app: gin
---
apiVersion: networking.k8s.io/v1beta1
kind: Ingress
metadata:
  name: prototype-ingress
  annotations:
    kubernetes.io/ingress.class: nginx
spec:
  tls:
  - hosts:
    - ${PROTOTYPE_NAME}.apps.live.cloud-platform.service.justice.gov.uk
  rules:
  - host: ${PROTOTYPE_NAME}.apps.live.cloud-platform.service.justice.gov.uk
    http:
      paths:
      - path: /
        backend:
          serviceName: analytical-platform-external-tool
          servicePort: 8080
