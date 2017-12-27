### kubernetes-dashboard
This dashboard is using the offical image:
- [kubernetes-dashboard v1.8.1](https://console.cloud.google.com/gcr/images/google-containers/GLOBAL/kubernetes-dashboard-amd64)
##### Installation
The dashboard is automatically installed on vagrant up
It will also create a default admin-user with full admin rights.
You can use it to login in the dashboard by following the documentation:
https://github.com/kubernetes/dashboard/wiki/Creating-sample-user

Basically, you can simply execute this command:
```
kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep admin-user | awk '{print $1}')
```
Then copy the token and paste it in the Login form: 
http://localhost:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/#!/login


##### Usage
With kubectl locally :
```
kubectl proxy
Starting to serve on 127.0.0.1:8001
```
and point your local browser to http://localhost:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/