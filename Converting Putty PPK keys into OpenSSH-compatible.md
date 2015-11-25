Converting Putty PPK keys into OpenSSH-compatible keys
=====================

## Intro

Use Puttygen!

## Short version:

	sudo apt-get install putty
	puttygen /path/to/key.ppk -O private-openssh -o /path/to/key_dsa

The converted keys should go into `~/.ssh` and be referenced in sites you set up within the `~/.ssh/config` file