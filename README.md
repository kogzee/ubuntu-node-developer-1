# ubuntu-node-developer

Vagrant/Puppet scripts to automate provisioning of a developer virtual machine (using Virtual Box)

This will provision a VM with

* Ubuntu 16.04
* Ubuntu Desktop
* Visual Studio Code
* Node JS/NPM
* Mongo DB
* Ruby (Required by Sass)
* Sass
* Grunt

Steps:

Install Virtual Box
https://www.virtualbox.org/wiki/Downloads

Install Vagrant 
https://www.vagrantup.com/downloads.html

Install Puppet Agent:

Mac:
https://downloads.puppetlabs.com/mac/10.11/PC1/x86_64/

Windows:
https://docs.puppet.com/puppet/4.7/reference/install_windows.html#download-the-windows-puppet-agent-package


Ensure these puppet modules are installed (correct the path as per your machine, so they are in the modues directory in this repo folder.  They can be installed elsewhere and copied to the folder)

sudo puppet module install -i ~/provisioning/node-developer/environments/development/modules puppetlabs/stdlib

sudo puppet module install -i ~/provisioning/node-developer/environments/development/modules puppetlabs/nodejs

sudo puppet module install -i ~/provisioning/node-developer/environments/development/modules puppetlabs/apt

sudo puppet module install -i ~/provisioning/node-developer/environments/development/modules puppetlabs/ruby

These can be installed to any location, but they may need to be copied to the modules folder in this repo's directory

Then open up a terminal and navigate to the folder with this repo and type:

```
vagrant up
```

If you want to stop the vm:

```
vagrant halt
```

If you want to destroy the vm:

```
vagrant destroy
```


You may have to restart the machine in the Virtual Box UI in order to see the Ubuntu GUI.

Note that Chrome has not been installed on this version.  To install chrome manually: (in the Ubuntu virtual machine):

```
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add - 
```

```
sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
```

```
sudo apt-get update
```

```
sudo apt-get install google-chrome-stable
```


