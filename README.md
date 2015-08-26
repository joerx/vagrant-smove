# A Vagrant Box 

Vagrant box for Smove projects. Contains node.js, grunt, sails, LAMPP, etc. See `bootstrap.sh` to 
see what exactly will be installed.

## Prerequisites

Requires [vagrant](http://vagrantup.com) and VirtualBox. Clone this repo into a folder next to your 
sources, run `vagrant up`. 

## Setup

This repo should be cloned into the same base folder that contains the projects you want to use 
inside the VM. Resulting structure should look something like this:

```
~/projects/
-- vagrant-smove  # <-- this repo
-- project1
-- project2
```

### Apache2

Edit `/etc/apache2/sites-available/000-default.conf` to match your setup.

## Usage

* Parent of the directory containing the `Vagrantfile` will be mapped into `/src` inside the VM
* Sails default port `1337` will be mapped to host port `1338`
