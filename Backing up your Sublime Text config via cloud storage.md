Backing up your Sublime Text config via cloud storage
==========================

[TOC]

## Summary

This guide covers one way to back up your Sublime Text config to a cloud storage provider. This makes it easy to restore your snippets, hotkeys, and other custom settings the next time you have to install Sublime Text.

This guide assumes you're running _at least_ Windows 7.

## Find and move your Sublime Text settings folder

First of all, completely close out of Sublime Text if you haven't done so already.

You should be able to find Sublime Text's settings folder in your AppData's Roaming folder. You can quickly navigate there by typing the following into the Run (Win+R) prompt:

	%APPDATA%

All of your Sublime Text settings are stored in the '**Sublime Text #**'' folder, **where # is the version of Sublime Text you're running**. Move this folder to your cloud storage service's folder. I opted for OneDrive, but feel free to use whichever storage service you prefer.

Next, copy the complete path to the relocated folder, including 'Sublime Text #' - you'll need this path for the next step.

For reference, your copied path should look like this:

> D:\path\to\OneDrive\Sublime Text 3\

## Make a symbolic link to your relocated Sublime Text settings folder

First, open a Command Prompt as an Administrator:

- Press the **Win** key to open up the Start Menu
- Type '**cmd**' (minus the quotes)
- Press **Ctrl+Shift+Enter** to automatically "Run as Admintstrator"

After you accept the UAC prompt, navigate to your AppData Roaming folder:

	cd %APPDATA%

Now you can make the actual symbolic link. Type the following, again **substituting # with the numerical version of Sublime Text you're running**:

	mklink /J "Sublime Text #" "D:\path\to\OneDrive\Sublime Text #\"

If all went well, you'll see the following message:

> Junction created for Sublime Text # <<===>> D:\path\to\OneDrive\Sublime Text #

On the other hand, if you see the following...

> Cannot create a file when that file already exists.

...delete the '**Sublime Text #**' folder in %APPDATA% and run the command again.

## Verifying the link

Once you finish making the symbolic link, open up Sublime Text. If you don't notice anything different, then you're done!

Thanks to the nature of symbolic links Sublime Text has no idea that anything's changed, so everything should continue to work as expected.

From here on out, whenever you make changes to your User settings, create snippets, or tweak any other package setting, these changes will get synced with your cloud storage service. Restoring these settings after reinstalling Sublime Text is as simple as recreating the symbolic link.

## Additional Reading

- [NTFS junction point](https://en.wikipedia.org/wiki/NTFS_junction_point)
	- Here's some additional information about Symbolic Links, more specifically the **junction point** we created with the `/J` flag we specified when calling `mklink`