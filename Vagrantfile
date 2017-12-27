# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.require_version ">= 1.6.0"

# Library to pass in parameters
require 'getoptlong'

DOCKERHUB_OPT='--dockerhub'
MOUNT_OPT='--mount'

opts = GetoptLong.new(
    # The path on the host that will be mounted on k8sworker under /data
    [ MOUNT_OPT, GetoptLong::OPTIONAL_ARGUMENT ],
    [ DOCKERHUB_OPT, GetoptLong::OPTIONAL_ARGUMENT ]
)

# Mount /tmp if no specific directory is chosen by the user
hostMount='/tmp'
guestMount='/data'
dockerLogin=false
opts.each do |opt, arg|
  case opt
    when MOUNT_OPT
      hostMount=arg
    when DOCKERHUB_OPT
      dockerLogin=true
  end
end

boxes = [
    {
        :name => "k8smaster",
        :eth1 => "192.168.8.10",
        :mem => "1024",
        :cpu => "1"
    },
    {
        :name => "k8sworker",
        :eth1 => "192.168.8.11",
        :mem => "2048",
        :cpu => "2"
    },
]

Vagrant.configure(2) do |config|

  config.vm.box = "ubuntu/xenial64"

  boxes.each do |opts|
      config.vm.define opts[:name] do |config|
        config.vm.hostname = opts[:name]

        config.vm.provider "virtualbox" do |v|
          v.customize ["modifyvm", :id, "--memory", opts[:mem]]
          v.customize ["modifyvm", :id, "--cpus", opts[:cpu]]
        end

        config.vm.network :private_network, ip: opts[:eth1]
      end
  end

  config.vm.define "k8smaster" do |k8smaster|
    k8smaster.ssh.forward_agent = true
    k8smaster.vm.provision "shell", inline: <<-SHELL
      set -e
      set -x
      sed 's/127\.0\.0\.1.*k8s.*/192\.168\.8\.10 k8smaster/' -i /etc/hosts
      #echo "192.168.8.11	k8sworker" >> /etc/hosts
      #kubernetes-xenial-unstable 

      apt-get update && apt-get install -y apt-transport-https
      curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
      cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF
      apt-get update
      apt-get upgrade -y
      apt-get install -y docker.io
      apt-get install -y kubelet kubeadm kubectl kubernetes-cni
      apt-get install -y nfs-common
      echo "export KUBERNETES_SERVICE_HOST=192.168.8.10" > /etc/profile.d/kubernetes.sh
      echo "export KUBERNETES_SERVICE_PORT=6443" >> /etc/profile.d/kubernetes.sh
      echo "export KUBECONFIG=/vagrant/kubeconfig/admin.conf" >> /etc/profile.d/kubernetes.sh
      kubeadm init --apiserver-advertise-address 192.168.8.10 --pod-network-cidr 10.244.0.0/16 --kubernetes-version v1.9.0 --token 54c315.78a320e33baaf27d 
      cp -rf  /etc/kubernetes/admin.conf /vagrant/kubeconfig/      
      export KUBECONFIG=/etc/kubernetes/admin.conf
      kubectl patch daemonset kube-proxy -n kube-system --type='json' -p='[{"op": "add", "path": "/spec/template/spec/containers/0/command/2", "value":"--proxy-mode=userspace"}]'
      sleep 60
#     # Weave Net
      #kubectl create -f /vagrant/networking/kube-weave.yml
      kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"
      # Flannel 
      #kubectl create -f /vagrant/networking/kube-flannel.yml
    SHELL
  end

 config.vm.define "k8sworker" do |k8sworker|
   k8sworker.ssh.forward_agent = true
   k8sworker.vm.synced_folder "#{hostMount}", "#{guestMount}"
   k8sworker.vm.provision "shell", inline: <<-SHELL
      set -e
      set -x
      sed 's/127\.0\.0\.1.*k8s.*/192\.168\.8\.11 k8sworker/' -i /etc/hosts
      #echo "192.168.8.10	k8smaster" >> /etc/hosts
      apt-get update && apt-get install -y apt-transport-https
      curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
      cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF
      apt-get update
      apt-get upgrade -y
      apt-get install -y docker.io
      apt-get install -y kubelet kubeadm kubectl kubernetes-cni
      # Tell kubelet to use /root for its HOME.  This will help setup docker login.
      sed -i '/\[Service\]/a Environment="HOME=/root"' /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
      apt-get install -y nfs-common
      echo "export KUBERNETES_SERVICE_HOST=192.168.8.10" > /etc/profile.d/kubernetes.sh
      echo "export KUBERNETES_SERVICE_PORT=6443" >> /etc/profile.d/kubernetes.sh
      kubeadm join --ignore-preflight-errors=all --discovery-token-unsafe-skip-ca-verification --token 54c315.78a320e33baaf27d 192.168.8.10:6443 
      sleep 120
      export KUBECONFIG=/vagrant/kubeconfig/admin.conf
      kubectl create -f /vagrant/monitoring/kube-heapster.yml
      #kubectl create -f /vagrant/dashboard/kube-dashboard.yml
      kubectl create -f /vagrant/dashboard/admin-user.yml
      kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/master/src/deploy/recommended/kubernetes-dashboard.yaml
      wget --no-verbose -O /tmp/helm-v2.7.2-linux-amd64.tar.gz https://storage.googleapis.com/kubernetes-helm/helm-v2.7.2-linux-amd64.tar.gz
      tar -zxvf /tmp/helm-v2.7.2-linux-amd64.tar.gz --strip-components=1 -C /tmp
      kubectl create serviceaccount -n kube-system tiller
      kubectl create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:tiller
      /tmp/helm init --service-account=tiller --tiller-namespace=kube-system
      rm -rf /tmp/helm-v2.7.2-linux-amd64.tar.gz
      echo "export KUBECONFIG=/vagrant/kubeconfig/admin.conf" >> /etc/profile.d/kubernetes.sh
    SHELL

   if dockerLogin then
       k8sworker.vm.provision "shell", env: {"USERNAME" => Username.new, "PASSWORD" => Password.new}, inline: <<-SHELL
         set +x
         docker login -u $USERNAME -p $PASSWORD
       SHELL
   end
 end
end

class Username
  def to_s
    print "Please enter your dockerhub username and password.\n"
    print "Username: "
    STDIN.gets.chomp
  end
end

class Password
  def to_s
    begin
    system 'stty -echo'
    print "Password: "
    pass = URI.escape(STDIN.gets.chomp)
    ensure
    system 'stty echo'
    end
    pass
  end
end
