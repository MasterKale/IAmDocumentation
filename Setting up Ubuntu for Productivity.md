Setting up Ubuntu/Mint for Productivity
=================

[TOC]

# Intro

This is a record of almost everything I do to configure a fresh copy of Ubuntu/Mint to a point where I can actually be productive with it. I plan on keeping this up-to-date with any other important tweaks I make to the system.

Each section is pretty much self-contained. None of them really rely on any of the others. In a sense this guide could also be seen as a compendium of mini-tutorials for installing and configuring various programs and features within Ubuntu-based distros. There are some Mint-specific references throughout, though, so don't be alarmed if you can't find something in a non-Mint distro.

**Take heed!** This guide started out as a Mint setup guide but I've since switched to Xubuntu as of 16.04. It's alright, though, because as I mentioned earlier this guide is basically customizations I make to a Debian-based distro.


## Partition Scheme

I decided to log down the partitioning scheme I use because it's simple and flexible:

1. EFI System Partition, 300MB
2. EXT4, /, 30GB (30720MB)
3. EXT4, /home, (remainder)
4. SWAP, swap, 2GB (2048MB)

Ubuntu now has UEFI support (you don't even need to turn off Secure Boot!) so the **EFI System Partition** takes the place of a FAT32 `/boot` partition I used to set up.

And I keep `/home` on its own partition so that I can (theoretically) easily reinstall over `/` and preserve all of my personal files. This of this as installing Windows on `C:\` but keeping Documents/Desktop/etc... on `D:\`.

Speaking of UEFI and Secure Boot: there was one final step I needed to take after setting up the above partitions (making sure to select `/dev/sda/` as the location to install the bootloader). Namely, I needed to tell the UEFI to trust the signed Ubuntu bootloader that was just installed:

1. Go into UEFI (F2 for this particular Acer laptop)
2. Set a 'Supervisor Password'
3. Go into BIOS-Settings > Security
4. Select HDD0
5. Select EFI
6. Select 'ubuntu'
7. Select 'shimx64.efi'
8. Enter a name to appear in the list of bootable devices, I chose 'xubuntu'
9. Save changes and exit

That should get UEFI to boot the OS that was just installed. If you don't do these steps, the OS will never boot **and you'll scratch your head for a couple of hours wondering what the hell is going wrong and whether you should just use Legacy Boot mode (DON'T DO THIS, GET UEFI SECURE BOOT WORKING, IT'S ONE EXTRA STEP, JEEEEZUS).**

## Update the OS completely

This is a pretty typical first step:

	sudo apt-get update && sudo apt-get upgrade

You can also tack on a `-y` to the end of `upgrade` if you just want it to run.


## Turn on the firewall

I don't know why the firewall is off by default but it's easy to turn on:

	sudo ufw enable


## Install Solaar

It seems silly to place this so far up the list of things to install, but I rely on my Logitech products to get things done. Unfortunately on the day I brought my new laptop into work I'd forgotten to take the Unifying Receiver off of the other laptop I was using. As luck would have it, there was another Receiver tucked inside the keyboard. Thanks to [Solaar](https://pwr.github.io/Solaar/) I was able to transfer both my keyboard and mouse to the second Receiver with no problem!

To get started, add the Solaar repository to apt:

	sudo add-apt-repository ppa:daniel.pavel/solaar && sudo apt-get update

Then install Solaar like any other program:

	sudo apt-get install solaar


## Install IBus IME

Japanese language entry is important to me on a day-to-day working basis. I'm partial to Microsoft's IME on Windows but, well, this is Linux and I've come to prefer the Google-IME-derived **Mozc** IME. It's an extension of IBus, though, so first we have to enable IBus.

I went the GUI route to install this in Mint:

* Click **Menu**, then search for '**language**'
* Click **Language Settings**, then select the **Input Method** section
* Click the **Add support for IBus** button

You can also install this via the command line:

	sudo apt-get install ibus ibus-clutter ibus-gtk ibus-gtk3 ibus-qt4


## Install Mozc

You *should* be able to install Mozc with this command:

	sudo apt-get install ibus-mozc mozc-server mozc-data mozc-utils-gui

Accept any prerequisites it might need.


## Enable Mozc

Mozc needs to be enabled from within IBus Preferences:

* Click **Menu**, then search for "ibus"
* Click **Keyboard Input Methods**, then select the **Input Method** tab
	* If you're prompted to start the **IBus Daemon**, go ahead and click **Yes**
* Check the **Customize active input methods** box if it isn't already
* From the dropdown, click **Show all input methods**, select **Japanese**, then click **Mozc**
* Click **Add** to add Mozc to the list of input methods

By default you can switch between English and Mozc with **Ctrl+Space**.

If you're coming from the Microsoft IME, you might be more comfortable using **Alt+`** (grave) to change languages. It's possible to use this same shortcut in Mint, but by default Mint has this bound to the **Cycle through open windows of the same application* shortcut. To reassign this shortcut, you must first disable it:

* Click **Menu**, then search for '**shortcut**'
* Click **Keyboard**, then click the **Shortcuts** tab
* Under **General**, click **Cycle through open windows of the same application**
* Beneath it, select the keyboard binding that says `` Alt+` ``, then press **Backspace** to clear it

Next, change the IBus language switch shortcut:

* Re-open IBus Preferences
* Click the **...** button next to the **Next input method** textbox
* Click the **...** button next to the **Key code** textbox
* Click the **disabled** text to start key recognition mode, then press the `` ` `` (grave) key
* Under **Modifiers**, click **Alt**, then click **Apply**

You should now see `<Alt>grave` in the **Next input method** textbox and immediately be able to use it to switch between input methods.

By the way, I tried using `<Super>space` to switch IMEs (this is how Windows 8/10 handles it) but I had to hold down the key combination to get it to fire. The delay is probably caused by this key combination being assigned somewhere else in the OS but I wasn't able to find out where (yes, I searched all the Keyboard shortcuts!). **Alt+`** is just as familiar so I stuck with it instead.


## Install Sublime Text 3

Grab the installer for Sublime Text 3 from the official website: http://www.sublimetext.com/3

In preparation for another step later on, go ahead and [install Package Control](https://packagecontrol.io/installation).


## Install exFAT support

Just in case you try to transfer files using a USB stick formatted as exFAT:

	sudo apt-get install exfat-fuse


## Install Virtual Box

The repository with up-to-date versions of Virtual Box needs to be added manually. Start by editing `additional-repositories.list`:

	sudo nano /etc/apt/sources.list.d/additional-repositories.list

Add this line to it:

	# Change 'trusty' to your repo's code word!
	# From https://www.virtualbox.org/wiki/Linux_Downloads:
	# "According to your distribution, replace 'vivid' by 'utopic', 'trusty', 'raring', 'quantal', 'precise', 'lucid', 'jessie', 'wheezy', or 'squeeze'."
	deb http://download.virtualbox.org/virtualbox/debian trusty contrib

To download from this repository we need to add the Oracle public key to our system:

	wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo apt-key add -

Once you've done that, install VirtualBox:

	sudo apt-get update
	sudo apt-get install VirtualBox-5.0

When you're done, I'd highly recommend grabbing the VirtualBox Extension Pack from https://www.virtualbox.org/wiki/Downloads. The file's the same for all OSs. When it'd done downloading you should be able to double-click it to have VirtualBox install it.

Additional Linux installation information can be found here: https://www.virtualbox.org/wiki/Linux_Downloads


## Install Mercurial and TortoiseHG

Install Mercurial, and TortoiseHG to assist in writing commit logs:

	sudo apt-get install mercurial && sudo apt-get install tortoisehg

TortoiseHg comes with a useful GUI for managing commits. You can activate this from any Mercurial repo by running `thg` from the terminal while in a folder containing a `.hg` subfolder.

## Install git-cola (for Git GUI)

Git is already installed, so we just need to install a graphical frontend to make it easier to write commit logs
	
	sudo apt-get install git-cola

From this point on you can activate git-cola by navigating to a repo folder containing a `.git` subfolder and running `git-cola` via the terminal.

## Additional Python3 setup

First, let's install pip3:

	sudo apt-get install python3-pip

Python 2 isn't going anywhere any time soon. For backwards-compatibility reasons it's a Bad Idea&trade; to try and point the `python` console command to Python3. Just deal with typing `python3` and `pip3` instead, at least until you get `virtualenv` installed. After that everything should be developed inside a virtual environment, within which `python` will point to `python3`.

On that note, let's install a couple of global Python tools:

	sudo pip3 install virtualenv
	sudo pip3 install httpie
	sudo pip3 install pep8

I also find a longer `max-line-length` more comfortable to work with, and I prefer to set the longer length system-wide. This'll manifest most directly within Sublime Text, which calls `pep8` via `SublimeLinter`.

Simply put, add the following to `~/.config/pep8`:

>[pep8]
max-line-length = 100

And that's all it takes.

## Install PostgreSQL and PGAdmin III

If you're not picky about what version of PostgreSQL you install, grab both with the following command:

	sudo apt-get install postgresql && sudo apt-get install pgadmin3

They'll both get installed with default settings. You can then access PostgreSQL from the command line:

	sudo su - postgres
	psql

While you're here, go ahead and set a password for the `postgres` user:

	postgres=# \password
	Enter new password: <Enter password>
	Enter it again: <Confirm password>
	postgres=# 

You'll need to enter the new password into PGAdmin when you're setting up the connection to `localhost`.

## Install Slack

Just go ahead and grab Slack's official Linux client: https://slack.com/downloads


## Set up a Brother HL-2170W for wireless printing

I have a wireless Brother printer that won't work if you just try to install the printer as its detected in Mint's Printers menu. A better way is to use Brother's well-documented, and highly-Linux-supportive Driver Install Tool:

> http://support.brother.com/g/b/downloadend.aspx?c=eu_ot&lang=en&prod=hl2170w_all&os=128&dlid=dlf006893_000&flang=4&type3=625

Download the bash script, extract it, and then run it:

	sudo bash linux-brprinter-installer-2.0.0-1

Choose `yes` when prompted whether or not you want to specify a DeviceURI. Then you can connect to the printer by IP, or by its automatically created connection URI if you're doing this after trying to install it via Printers.


## Create soft-links to settings stored in ~/.config/

I discovered the joy of soft links so I went ahead and started moving program configs into cloud storage to preserve them during reinstalls. I created a `Settings` folder in Copy for these settings. To create a soft link and trick your programs into using these relocated settings, follow this general workflow:

	cd ~/.config/sublime-text-3/Packages
	# Delete ./User/ if it exists
	ln -s ~/Copy/Settings/SublimeText3/ User

This should create a softlink at `~/.config/sublime-text-3/Packages/User/` that points to `~/Copy/Settings/SublimeText3/`. In this example Sublime Text is none the wiser as to where its settings actually reside, and from that point on any change made to its settings will get synced up to cloud storage.

The trickiest part is figuring out which files to back up. It appears that most programs are nice enough to drop their settings into `~/.config/`, so that's a good place to start looking.


## Install Dropbox with Thunar integration

Dropbox is still a useful program, even if their plans are a bit inflexible. You can install it with a simple `apt-get` command:

	sudo apt-get install dropbox

Afterwards, if you want Dropbox-specific options in Thunar's right-click menu, you'll need to install the integration plugin:

	sudo apt-get install thunar-dropbox-plugin

From that point on you can perform various Dropbox tasks (including getting shareable links) by right-clicking from within the Dropbox folder.

Note that if you're using another file manager you'll want to track down its specific Dropbox integration plugin. I'm using Thunar because it came integrated with XFCE.

There's a bug with Dropbox and the newer version of Ubuntu's notification area. This manifests as a red 'not permitted' icon appearing within the notification area. The fix is pretty simple for now - to start, shut down Dropbox:

	dropbox stop

Then, go into Sessions** and Startup > Application Autostart** and find the entry for Dropbox. When you do, double-click it and replace the `dropbox start -i` command with the following:

> dbus-launch dropbox start

You can run that same command in the terminal to bring Dropbox back up. The familiar white box icon should now be visible.

## Getting wireless working

The **Qualcomm Atheros QCA6174** wireless card in my new laptop was _too new_ so I had to grab updated drivers for it. Fortunately it was made by Qualcomm so I could simply grab [the official open-source drivers for it](https://github.com/kvalo/ath10k-firmware):

	# From http://ubuntuforums.org/showthread.php?t=2323812&page=2
	sudo rm /lib/firmware/ath10k/QCA6174/hw3.0/*
	sudo wget -O /lib/firmware/ath10k/QCA6174/hw3.0/board.bin https://github.com/kvalo/ath10k-firmware/blob/master/QCA6174/hw3.0/board.bin?raw=true
	sudo wget -O /lib/firmware/ath10k/QCA6174/hw3.0/board-2.bin https://github.com/kvalo/ath10k-firmware/blob/master/QCA6174/hw3.0/board-2.bin?raw=true
	sudo wget -O /lib/firmware/ath10k/QCA6174/hw3.0/firmware-4.bin https://github.com/kvalo/ath10k-firmware/blob/master/QCA6174/hw3.0/firmware-4.bin_WLAN.RM.2.0-00180-QCARMSWPZ-1?raw=true

Once these three updates drivers are in place, a restart was all it took to get back wireless and Bluetooth functionality. 

For future reference, I was also able to verify the model of my wireless card with the `lspci` command:

>matt@acer-mattspire:~$ lspci
...
01:00.0 Network controller: Qualcomm Atheros QCA6174 802.11ac Wireless Network Adapter (rev 32)

And while diagnosing this issue I ran `dmesg | grep 'ath10k'` to see messages like this that helped identify the actual error:

>[ 3.657434] ath10k_pci 0000:01:00.0: Direct firmware load for ath10k/cal-pci-0000:01:00.0.bin failed with error -2
[ 3.657630] ath10k_pci 0000:01:00.0: Direct firmware load for ath10k/QCA6174/hw3.0/firmware-5.bin failed with error -2
[ 3.657632] ath10k_pci 0000:01:00.0: could not fetch firmware file 'ath10k/QCA6174/hw3.0/firmware-5.bin': -2
[ 3.722223] ath10k_pci 0000:01:00.0: Direct firmware load for ath10k/QCA6174/hw3.0/board-2.bin failed with error -2

# Additional Resources

* Currently tesing out the RAVEfinity theme and icon set:
	* Theme: http://www.ravefinity.com/p/download-ambiance-radiance-flat-colors.html
	* Icon Set: http://www.ravefinity.com/p/vivacious-colors-gtk-icon-theme.html
	* Current Theme: Radiance-Flat (Blue-Spring-Pro)
	* Current Icon Set: Vivacious-Light (Blue)
	* Window Style: Radiance-Flat (Blue-Spring)