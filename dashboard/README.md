### kubernetes-dashboard
This dashboard is using the offical image:
- [kubernetes-dashboard v1.6.1](https://console.cloud.google.com/gcr/images/google-containers/GLOBAL/kubernetes-dashboard-amd64)
##### Installation
The dashboard is automatically installed on vagrant up
##### Usage
With kubectl locally :
```
kubectl proxy
Starting to serve on 127.0.0.1:8001
```
and point your local browser to http://127.0.0.1:8001