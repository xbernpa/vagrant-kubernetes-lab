### heapster
This moninotor is using this image :
- [heapster v1.5.0](https://console.cloud.google.com/gcr/images/google-containers/GLOBAL/heapster-amd64)
##### Installation
This monitor is automatically installed on vagrant up
##### Usage
Standalone, container cluster conitoring and performance analysis can be viewed through the dashboard.
### influxdb-grafana
This is a visual add-on to heaster and is using the following images :
- [heapster-influxdb v1.3.3](https://console.cloud.google.com/gcr/images/google-containers/GLOBAL/heapster-influxdb-amd64)
- [heapster-grafana v4.4.3](https://console.cloud.google.com/gcr/images/google-containers/GLOBAL/heapster-grafana-amd64)
##### Installation
Install with kubectl :
```
kubectl create -f monitoring/kube-influxdb-grafana.yml
```
##### Usage
Locally create a port-forward :
```
kubectl port-forward -n kube-system "$(kubectl get -n kube-system pod --selector=k8s-app=grafana -o jsonpath='{.items..metadata.name}')" 3000
```
and point your browser to http://127.0.0.1:3000
### weavescope
This monitor automatically generates a map of your application, enabling you to intuitively understand, monitor, and control your containerized, microservices based applicationThis is a visual add-on to heaster and is using this image :
- [scope v1.6.7](https://hub.docker.com/r/weaveworks/scope/)
##### Installation
Install with kubectl :
```
kubectl apply --namespace kube-system -f "https://cloud.weave.works/k8s/scope.yaml?k8s-version=$(kubectl version | base64 | tr -d '\n')"
```
##### Usage
Locally create a port-forward :
```
kubectl port-forward -n kube-system "$(kubectl get -n kube-system pod --selector=weave-scope-component=app -o jsonpath='{.items..metadata.name}')" 4040
```
and point your browser to http://127.0.0.1:4040 