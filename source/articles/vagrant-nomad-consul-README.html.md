# Vagrant Nomad cluster
[![Open Source Helpers](https://www.codetriage.com/labarhack/vagrant-nomad-consul/badges/users.svg)](https://www.codetriage.com/labarhack/vagrant-nomad-consul)

Start nomad cluster with consul server (auto join).

## Prerequisites

* VirtualBox Version 6.0
* Vagrant 2.2.5
* Ansible 2.8.2

## Setup

```
export SERVER_COUNT=1 # default: 1
export CLIENT_COUNT=1 # default: 1
```
## Build vagrant box

See [README](packer/README.md) to build box with packer.
```
export BOX_NAME='labarhack/nomad_consul_20190702.0'
```

## Start vagrant

```
vagrant up
vagrant status
Current machine states:

server_1           running (virtualbox)
server_2            running (virtualbox)
client_1            running (virtualbox)
client_2            running (virtualbox)

This environment represents multiple VMs. The VMs are all listed
above with their current state. For more information about a specific
VM, run `vagrant status NAME`.
```

## UI

* Consul: http://localhost:8500
* Nomad: http://localhost:4646

## Test

``` 
export NOMAD_ADDR=http://localhost:4646
export CONSUL_HTTP_ADDR=http://localhost:8500

nomad node status
ID        DC   Name            Class   Drain  Eligibility  Status
75b086ab  dc1  client-2  <none>  false  eligible     ready
e0775890  dc1  client-1  <none>  false  eligible     ready


nomad server members
Name                   Address        Port  Status  Leader  Protocol  Build  Datacenter  Region
server-1.global  192.168.50.61  4648  alive   true    2         0.9.3  dc1         global
server-2.global  192.168.50.62  4648  alive   false   2         0.9.3  dc1         global


consul members
Node             Address             Status  Type    Build  Protocol  DC   Segment
server-1  192.168.50.61:8301  alive   server  1.5.2  2         dc1  <all>
server-2  192.168.50.62:8301  alive   server  1.5.2  2         dc1  <all>
client-1  192.168.50.81:8301  alive   client  1.5.2  2         dc1  <default>
client-2  192.168.50.82:8301  alive   client  1.5.2  2         dc1  <default>


nomad job run nomad/echo-server.nomad
==> Monitoring evaluation "56535392"
    Evaluation triggered by job "echo-server"
    Allocation "69708195" created: node "e0775890", group "sample"
    Evaluation status changed: "pending" -> "complete"
==> Evaluation "56535392" finished with status "complete"

nomad job status
ID           Type     Priority  Status   Submit Date
echo-server  service  50        running  2019-07-15T11:38:04+02:00
```
