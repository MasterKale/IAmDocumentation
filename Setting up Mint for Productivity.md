Setting up Mint for Productivity
=================

[TOC]

# Intro

This is a record of everything I did to configure a fresh copy of Mint 17.2 to a point where I could actually be productive with it. I plan on keeping this up-to-date with any other important tweaks I make to the system.

Each section is pretty much self-contained. None of them really rely on any of the others. In a sense this guide could also be seen as a compendium of mini-tutorials for installing and configuring various programs and features within Ubuntu-based distros. There are some Mint-specific references throughout, though, so don't be alarmed if you can't find something in a non-Mint distro.

**Take heed!** I've opted for the XFCE version of Mint. If some of these commands fail, you might be using a non-XFCE environment. I'll try and make a note of when you might run into an issue because of this.

## Update Mint completely

This is a pretty typical first step:

	sudo apt-get update && sudo apt-get upgrade

You can also tack on a `-y` to the end of `upgrade` if you just want it to run. Alternatively, you can update everything via Mint's *Update Manager*:

* Click **Menu**, then search for '**update**'
* Click **Update Manager**

You can also bring this up via the Shield icon that appears next to the clock.


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

If this doesn't work, selecting these four packages within the Synaptic Package Manager will also work.

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

Fortunately Sublime Text can be installed from the console:

	sudo apt-get install sublime-text

In preparation for another step later on, go ahead and [install Package Control](https://packagecontrol.io/installation).

You can also make Sublime Text the default editor of text files via the **Preferred Applications** applet.


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

## Install gitg (for Git GUI)

Git is already installed, so we just need to install a graphical frontend to make it easier to write commit logs
	
	sudo apt-get install gitg

From this point on you can activate gitg by navigating to a repo folder containing a `.git` subfolder and running `gitg` via the terminal.

## Install pip3

Pretty simple:

	sudo apt-get install python3-pip

By the way Python 2 isn't going anywhere any time soon. For backwards-compatibility reasons it's a Bad Idea&trade; to try and point the `python` console command to Python3. Just deal with typing `python3` and `pip3` instead, at least until you get `virtualenv` installed. After that everything should be developed inside a virtual environment, within which `python` will point to `python3`.

On that note, let's install a couple of global Python tools:

	sudo pip3 install virtualenv
	sudo pip3 install httpie

## Install PostgreSQL and PGAdmin III

If you're not picky about what version of PostgreSQL you install, grab both with the following command:

	sudo apt-get install postgresql && sudo apt-get install pgadmin3

They'll both get installed with default settings. You can then access PostgreSQL from the command line:

	sudo su - postgres
	psql


## Install ScudCloud (Slack)

If you happen to use Slack, ScudCloud is a highly-recommended (but unofficial) client:

	sudo apt-add-repository -y ppa:rael-gc/scudcloud
	sudo apt-get update
	sudo apt-get install scudcloud

You can also use Slack's official Linux client: https://slack.com/downloads. I ended up going with ScudCloud, though, because it seemed a tiny bit less resource intensive than the official client.


## Set up a Brother HL-2170W for wireless printing

I have a wireless Brother printer that won't work if you just try to install the printer as its detected in Mint's Printers menu. A better way is to use Brother's well-documented, and highly-Linux-supportive Driver Install Tool:

> http://support.brother.com/g/b/downloadend.aspx?c=eu_ot&lang=en&prod=hl2170w_all&os=128&dlid=dlf006893_000&flang=4&type3=625

Download the bash script, extract it, and then run it:

	sudo bash linux-brprinter-installer-2.0.0-1

Choose `yes` when prompted whether or not you want to specify a DeviceURI. Then you can connect to the printer by IP, or by its automatically created connection URI if you're doing this after trying to install it via Printers.


## Install Copy

Almost every popular cloud storage solution has neglected Linux. In addition, the ones that *do* offer Linux clients have kinda pricey per-month pro plans that come with 1TB of storage, most of which will go un-utilized.

Copy, on the other hand, is ticking all the right boxes: it has a Linux client, you get 15GB of free storage, and they offer a nice intermediate paid tier with 250GB of storage for $5/mo. You can also use [referral bonuses](https://copy.com?r=2wqKA3) to get up to an additional 25GB of free storage!

To start, add a third-party repository that exists to make Copy available via the command line:

	sudo add-apt-repository ppa:paolorotolo/copy

Then, install Copy:

	sudo apt-get update
	sudo apt-get install copy

You'll find Copy in `/opt/copy-client/`.

You can also manually install Copy if you don't trust the PPA. I say "manually" because it involves decompressing some files and running one of the executables.

Start by downloading Copy:

> https://copy.com/install/linux/Copy.tgz

Then, decompress the files somewhere. I placed them in `~/.copy/copy_app/` to keep everything compartmentalized.

Regardless of how you installed Copy, check out the `README` file for a description of all three methods of running Copy. I opted for `CopyAgent`, which places an icon in the system tray and lets you easily monitor the status of Copy.

You'll also be prompted to place a Copy folder somewhere. I pointed it to `~/Copy/` and moved `Documents` and `Desktop` inside there to try and make Copy as transparent as possible.

And if you want to enable additional Copy-specific options in your File Manager's right-click menu, you can run the following to do so:

	sudo /opt/copy-client/CopyAgent -installOverlay

The overlays appear to be supported in Nautilus and Caja.


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
