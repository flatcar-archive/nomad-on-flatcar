# CLC configs to deploy Nomad on Flatcar

Based on https://github.com/travier/fedora-coreos-nomad.

## Generate

```
# generate ignition files

export RESOURCE_GROUP=resource-group-name
export DATACENTER=datacenter-name
export BOOTSTRAP_IP=10.0.0.4
make

# log in to azure
az login

# deploy on azure
make deploy
```
