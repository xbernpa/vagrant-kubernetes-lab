### nfs-provisioner
This dynamic NFS storage provisioner is using this image:
- [nfs-provisioner v1.0.8](https://quay.io/repository/kubernetes_incubator/nfs-provisioner?tag=v1.0.8&tab=tags)
##### Installation
Install with kubectl :
```
kubectl create -f storage/kube-nfsprovisioner.yml
```
In order to avoid having to supply annotations to the persistent volume claim, make the provisioner the default one :
```
kubectl patch storageclass example-nfs -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'
```
##### Example
Create a pvc and a pod - test-pvc.yml :
```
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: test-pvc
  annotations:
    volume.beta.kubernetes.io/storage-class: "example-nfs"
spec:
  accessModes:
    - ReadWriteMany
  resources:
    requests:
      storage: 1Gi
---
kind: Pod
apiVersion: v1
metadata:
  name: test-pvc-pod
spec:

  volumes:
    - name: test-pv
      persistentVolumeClaim:
       claimName: test-pvc

  containers:
    - name: test-pvc-pod
      image: nginx
      ports:
        - containerPort: 80
          name: "http-server"
      volumeMounts:
      - mountPath: "/usr/share/nginx/html"
        name: test-pv
```
Create the resources in the cluster :
```
kubectl create -f test-pvc.yml
```
You can validate that the pvc is bounded :
```
kubectl get pvc
NAME       STATUS    VOLUME                                     CAPACITY   ACCESSMODES   STORAGECLASS   AGE
test-pvc   Bound     pvc-c593d8bf-5aad-11e7-8939-0225fa80d66e   1Gi        RWX           example-nfs    12s
```
and that volume is mounted in the pod :
```
kubectl exec -ti test-pvc-pod mount
[...]
10.100.226.60:/export/pvc-c593d8bf-5aad-11e7-8939-0225fa80d66e on /usr/share/nginx/html type nfs4 (rw,relatime,vers=4.0,rsize=1048576,wsize=1048576,namlen=255,hard,proto=tcp,port=0,timeo=600,retrans=2,sec=sys,clientaddr=10.0.2.15,local_lock=none,addr=10.100.226.60)
```