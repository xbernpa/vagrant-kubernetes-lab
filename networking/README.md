### weavenet
This network add-on provides networking and network policy and is using these offical images:
- [weave-kube v2.0.0](https://hub.docker.com/r/weaveworks/weave-kube/)
- [weave-npc v2.0.0](https://hub.docker.com/r/weaveworks/weave-npc/)
##### Installation
The network add-on is automatically installed on vagrant up
### flannel
This network add-on provides an overlay network provider and is using this image :
- [flannel v0.7.1] (https://quay.io/repository/coreos/flannel?tab=tags)
##### Installation
Before doing vagrant up, edit the Vagrantfile and comment weave entry and uncomment flannel.
