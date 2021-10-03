This directory is meant to setup a ready to go salt master/minion environment for testing

# Installation:

1. Install virtualbox
2. Install vagrant

From inside the directory run:
```
vagrant up
```
  
Once vagrant finishes you should have at least two vms.

You can ssh into the saltmaster via:
```
vagrant ssh saltmaster
```
 
Verify minions have checked into saltmaster:
```
sudo salt '*' test.ping
```

# Vagrantfile notes

Please see vagrant file if you want to change:
* Hardware specs
* Hostnames
* Domain
* Number of minions
* Base image (centos or ubuntu tested)
  
# Process for reseting a minion:
1. Destroy minion you want to rebuild:
```
vagrant destroy minion1
```
  
2. Remove destroyed minion from saltmaster:

```
vagrant ssh saltmaster -c "sudo salt-key -y -d minion1"
```
  
3. Rebuild minion
```
vagrant up minion1
```
