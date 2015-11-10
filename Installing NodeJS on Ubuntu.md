Installing Bower on Ubuntu/Debian
======================

I wouldn't think a guide like this would be needed but I ran into a weird issue (and its solution) while installing Bower. I figured I should document it for later. 

## Prerequisites

This guide will probably work with any Ubuntu- or Debian-based distro. I can confirm that this works on Ubuntu-based Mint.

## Install NodeJS

	sudo apt-get install nodejs

## Install NPM

	sudo apt-get install npm

## Install Bower

	sudo npm install bower -g

## Troubleshooting

### Calling `bower` yields */usr/bin/env: node: No such file or directory*
I ran into issues with running Bower after executing all of the above commands. It turns out there's an issue with NodeJS when it's installed via a package manager (apt, etc...). Namely, NodeJS is installed as 'nodejs', while Bower tries to invoke it by calling 'node'.

To fix it, create a symbolic link with the following command:

	ln -s /usr/bin/nodejs /usr/bin/node

You should now be able to call NodeJS with `node`, and Bower should now function as expected.