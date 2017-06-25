# vagrant-kubernetes-lab
This project is to provide a simple local Kubernetes cluster with a master and a worker node for testing purpose.

Vagrant was chosen for being able to run on linux, windows and mac hosts.

## Prequirements
Only tested on the lastest release of :
- Vagrant : https://www.vagrantup.com/downloads.html
- VirtualBox : https://www.virtualbox.org/wiki/Downloads

## Default provisioning
vagrant up will provide a 2 ubuntu xenial vms for a kubernetes cluster with :
- latest stable v1.6.6 kubernetes control plane
- latest stable v2.0.0 weave network cni 
- latest stable v1.6.1 kubernetes-dashboard
- latest stable v1.3.0 heapster

## Extras
Extras have been added to be installed if required.
### monitoring
kube-weave-scope
### storage
nfs-provisioner
### more to come