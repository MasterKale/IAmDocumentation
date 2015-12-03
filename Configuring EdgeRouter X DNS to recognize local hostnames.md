Configuring EdgeRouter X DNS to recognize local hostnames
=======================

[TOC]

##Introduction

The EdgeRouter X is an incredibly powerful gigabit router. The web UI is surprisingly robust as well, but for some things you have to get your hands dirty with the command line.

This guide will help you to configure the X to utilize DNS for accessing machines on your local network.

## Log into your router's console

You can connect to your router's console in one of two ways. If you want to access it via the web UI, log in to your router via your favorite browser. Then, click the **CLI** button in the upper-right corner of the screen:

Alternatively you can remote in using SSH via the command line. 

However you get there, run the following commands:

	ubnt@ubnt:~$ configure
	ubnt@ubnt# set service dhcp-server hostfile-update enable
	ubnt@ubnt# commit
	ubnt@ubnt# save
	ubnt@ubnt# exit

## Confirm local hostnames

	ubnt@ubnt:~$ cat /etc/hosts

## More information

EdgeOS User Manual: https://dl.ubnt.com/guides/edgemax/EdgeOS_UG.pdf
Thanks to https://www.reddit.com/r/Ubiquiti/comments/2wirn8/dns_initial_setup_edge_router_lite_16_lan_dns/