#!/usr/bin/env bash


#Retreive actual IP address
myIP=$(ifconfig eth1 | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p')

#Start Openshift cluster
oc cluster up --public-hostname=${myIP} --enable=* --base-dir=/home/vagrant/openshift-conf

# Assign cluster role permissions to the user developer
sleep 5
oc login -u system:admin
oc adm policy add-cluster-role-to-user cluster-admin developer

# Create a default projet calles my-app
sleep 5
oc new-project my-app

# Clone the entando custom resourses and install them 
git clone https://github.com/entando-k8s/entando-k8s-custom-model.git --branch v6.2.7
oc create -f entando-k8s-custom-model/src/main/resources/crd/

echo "----------------------------------------------------------------"

myIP=$(ifconfig eth1 | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p')
echo "Custom resource definition installed."
echo
echo "Now you can access to https://${myIP}:8443/console/ with the \"developer\" user"

# set iptables rule
sudo iptables -I INPUT -i docker0 -j ACCEPT
