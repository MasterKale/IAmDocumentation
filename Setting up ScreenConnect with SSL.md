Setting up ScreenConnect with SSL and an NGINX reverse-proxy
==============================

[TOC]

## Provision a server

Any server is fine so long as it's x86-based (maybe one day SC will update their instance of Mono for better ARM support...). For the purposes of this guide, let's assume you're using a VPS with the following specs:

- Ubuntu 14.04 LTS
- 1 CPU core
- 1GB RAM
- At least 15GB of storage
- Access to ports 80, 443, and 8041

## Install ScreenConnect

I like to install ScreenConnect into `/opt/`. To simplify things, here's a dual-purpose install/upgrade script I grabbed off of the [ScreenConnect website](http://help.screenconnect.com/Installing_the_server_software_on_a_Linux_machine):

	#!/bin/sh
	workingDirectory=~/scInstall
	downloadUrl="http://www.screenconnect.com/Download?Action=DownloadLatest&Platform=Linux&PreRelease=false"

	rm -rf $workingDirectory
	mkdir $workingDirectory
	cd $workingDirectory

	if which wget; then wget -O sc.tar.gz "$downloadUrl";
	else curl -L "$downloadUrl" > sc.tar.gz; fi;

	tar xf sc.tar.gz
	$(find . -name install.*)

	rm -rf $workingDirectory

Copy this into a bash script called **update_screenconnect.sh** and save it to `/opt/`. Once it's in place, run it to install the most recent ScreenConnect[^fn-install-script]:

	bash update_screenconnect.sh

Select default values when the installer prompts you. Once it's finished installing, you should be able to access the new ScreenConnect at `http://127.0.0.1:8040`. 

[^fn-install-script]: This same batch file can be used to update an existing ScreenConnect installation!

## Install NGINX

NGINX will take on reverse-proxying and 80->443 redirection duties, so go ahead and install it:

	sudo apt-get update && sudo apt-get install nginx

## Prepare your SSL cert, intermediate cert, and key file

First, get your SSL certificate and key file. In my case I grabbed a free Class 1 SSL certificate from [StartSSL](http://www.startssl.com/). I opted for a 2048-bit certificate using the SHA2 algorithm, and entered a random 32-character password for the key.

When all is said and done, you should end up with a .key file (ex. domainname.key) and a .crt file (domainname.crt). You'll also need to grab [StartSSL's intermediate certificate](https://www.startssl.com/certs/sub.class1.server.ca.pem) and maybe rename it to something more descriptive (ex. startssl.class1.intermediate.pem).

Create a folder for them on the server, then change into that directory:

	sudo mkdir sudo mkdir /etc/nginx/tls
	cd /etc/nginx/tls

Copy all three files into this directory (I opted for WinSCP). When you're done, your `tls` directory should look like this:

	matt@mattserver:/etc/nginx/tls$ ls
	domainname.crt
	domainname.key
	startssl.class1.intermediate.pem

Next, remove the password from your key file so that you don't have to enter it every time NGINX starts:
	
	# Back up the key first
	sudo cp domainname.key domainname.key.org
	# Overwrite domainname.key with an unlocked version
	sudo openssl rsa -in domainname.key.org -out domainname.key

`openssl` will prompt you for the random password you entered when you created the certificate at StartSSL.

Next, concatenate your SSL certificate with StartSSL's intermediate certificate:

	# Back up your original certificate
	sudo cp domainname.crt domainname.crt.orig
	# Combine the two files
	cat domainname.crt startssl.class1.intermediate.pem > domainname.bundle.crt

You *might* run into an issue later on if you don't check your combined certificate now. Open up domainname.bundle.crt and look for a line like this:

	...snip...
	-----END CERTIFICATE----------BEGIN CERTIFICATE-----
	...snip...

`END CERTIFICATE` and `BEGIN CERTIFICATE` need to be on separate lines! Place a line break after the fifth dash proceeding `END CERTIFICATE`:

	...snip...
	-----END CERTIFICATE-----
	-----BEGIN CERTIFICATE-----
	...snip...

Save the certificate, and you should be good to go.

## Prepare a strong Diffie-Helman group

I'm not well-versed on this stuff so I'm going to grab a quote from [weakdh.org](https://weakdh.org/):

> [Diffie-Hellman key exchange](https://en.wikipedia.org/wiki/Diffie%E2%80%93Hellman_key_exchange) is a popular cryptographic algorithm that allows Internet protocols to agree on a shared key and negotiate a secure connection. It is fundamental to many protocols including HTTPS, SSH, IPsec, SMTPS, and protocols that rely on TLS.

To further secure your server, you'll want to generate a unique group for NGINX. Fortunately, it's super simple:

	# If you're not already, move to the /tls/ folder
	cd /etc/nginx/tls
	# Generate a new group
	openssl dhparam -out dhparams.pem 2048

Once `openssl` finishes, your `/tls/` folder should look like this:

	matt@mattserver:/etc/nginx/tls$ ls
	dhparams.pem           domainname.crt.orig  startssl.class1.intermediate.pem
	domainname.bundle.crt  domainname.key
	domainname.crt         domainname.key.orig

## Configure NGINX

The below steps will help you configure NGINX to reverse-proxy requests to ScreenConnect listening on localhost, as well as  redirect port 80 traffic to port 443.

First, you'll need to specify ScreenConnect as an available site. Create an entry for it in NGINX's `/sites-available/`:

	sudo nano /etc/nginx/sites-available/screenconnect

Copy-and-paste this config that I ended up with after compiling info from a few sites:

	server {
		listen 443 default_server ssl;
		server_name sub.domainname.com;

		ssl on;

		## Tell NGINX where to find your certs
		ssl_certificate /etc/nginx/tls/domainname.bundle.crt;
		ssl_certificate_key /etc/nginx/tls/domainname.key;
		ssl_dhparam /etc/nginx/tls/dhparams.pem;

		ssl_session_cache shared:SSL:10m;
		ssl_session_timeout 5m;
		keepalive_timeout 60;
		
		## Enables the most up-to-date TLS connections
		ssl_protocols TLSv1 TLSv1.1 TLSv1.2;

		## Only allow modern ciphers. Older OSs won't be able to connect, but do you really care about Windows XP anymore?
		ssl_prefer_server_ciphers on;
		ssl_ciphers 'EECDH+AESGCM:EDH+AESGCM:AES256+EECDH:AES256+EDH';

		access_log  /var/log/nginx/app_screenconnect_access.log;
		error_log   /var/log/nginx/app_screenconnect__error.log;
	
		## Establish a reverse-proxy to ScreenConnect
		location / {
			proxy_pass http://127.0.0.1:8040;
			proxy_redirect off;
			proxy_set_header Host $host;
			proxy_set_header X-Real-IP $remote_addr;
			proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
			proxy_max_temp_file_size 0;
			client_max_body_size 50m;
			client_body_buffer_size 256k;
			proxy_connect_timeout 180;
			proxy_send_timeout 180;
			proxy_read_timeout 90;
			proxy_buffer_size 16k;
			proxy_buffers 4 64k;
			proxy_busy_buffers_size 128k;
			proxy_temp_file_write_size 128k;
		}
	}
	
	## Redirect requests from port 80 requests to the HTTPS-secured connection instead
	server {
		listen 80;
		server_name sub.domainname.com;
	  
		## 301 = permanent redirect, 302 = temporary redirect
		return 301  https://sub.domainname.com$request_uri;
	}

Then, enable the site:

	cd /etc/nginx/sites-enabled/
	sudo ln -s ../sites-available/screenconnect

And while you're in there, delete the default site from `/sites-enabled/` as well:

	# Remove the default site
	sudo rm default

Restart NGINX so that it picks up the new site:

	sudo service nginx restart

## Lock down ScreenConnect to only listen on localhost

Right now, you should be able to access your ScreenConnect install at `https://sub.domainname.com`. In addition, requests to `http://sub.domainname.com` should automatically redirect to `https://sub.domainname.com`.

However! Requests to `http://sub.domainname.com:8040` *will* go through over port 80. To close down this security hole, tweak ScreenConnect's `web.config` file and tell it to only listen for requests on `localhost`:

	sudo nano /opt/screenconnect/web.config

Scroll down until you find `WebServerListenUri`. Change this:

    <add key="WebServerListenUri" value="http://+:8040/">
    </add>

To this:

	<add key="WebServerListenUri" value="http://127.0.0.1:8040/">
    </add>

Save the changes to `web.config`, then restart ScreenConnect:

	sudo service screenconnect restart

Once ScreenConnect comes back up, requests to `http://sub.domainname.com:8040` should be refused. `https://sub.domainname.com` should still work fine, though, since NGINX is reverse-proxying those requests to `http://localhost:8040`.

# Additional reading

Here's some additional reading that I found useful while setting up my ScreenConnect and writing this guide:

- [[Step by Step] Linux, TLS & Nginx.](http://forum.screenconnect.com/yaf_postst2745_-Step-by-Step--Linux--SSL-and-Nginx.aspx#post10876)
	- This guide got me started and inspired me to compile this one
- [Strong SSL Security on nginx](https://raymii.org/s/tutorials/Strong_SSL_Security_On_nginx.html)
	- This site provided some additional insight on how to strengthen the (slightly outdated) site configuration featured in the above link
- [SSL Server Test (Powered by Qualys SSL Labs)](https://www.ssllabs.com/ssltest/)
	- Check your SSL security level with this site. After configuring my ScreenConnect as per this guide, I ended up with a score of 100/95/90/90.