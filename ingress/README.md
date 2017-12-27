### ngix-ingress-controller
This ingress controller is using the following images:
- [nginx-ingress-controller v0.9.0-beta.15](https://console.cloud.google.com/gcr/images/google-containers/GLOBAL/nginx-ingress-controller)
- [defaultbackend v1.4](https://console.cloud.google.com/gcr/images/google-containers/GLOBAL/defaultbackend)
##### Installation
Install with kubectl :
```
kubectl create -f ingress/kube-nginx-ingress-controller.yml
```
##### Example
Create a yaml containing a deployment, service and ingress - app1.yml :
```
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: app1
spec:
  replicas: 1
  template:
    metadata:
      labels:
        app: app1
    spec:
      containers:
      - name: app1
        image: dockersamples/static-site
        env:
        - name: AUTHOR
          value: app1
        ports:
        - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: appsvc1
spec:
  ports:
  - port: 80
    protocol: TCP
    targetPort: 80
  selector:
    app: app1
---
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: app1-ingress
  annotations:
    ingress.kubernetes.io/rewrite-target: /
spec:
  rules:
  - host: test.com
    http:
      paths:
      - backend:
          serviceName: appsvc1
          servicePort: 80
        path: /app1
```
NOTE : In order to get test.com/app1 to work you need to add to your local host file :
```
192.168.8.11	test.com
```
Create the resources in the cluster :
```
kubectl create -f app1.yml
```
Finally to validatepoint your local browser to http://test.com/app1
##### TODO
- Add configmap for custom configs