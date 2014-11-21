Hue Pi
====

A Meteor.JS Hue lights control panel for my Raspberry Pi.

###Quick Install

If you have NodeJS and Meteor already installed, setup is as simple as running `meteor` from the app directory.

Otherise:

* Install Node: [http://nodejs.org](http://nodejs.org)
* Install Meteor: `curl https://install.meteor.com | /bin/sh`

###Authentication

The first time you launch Hue Pi you'll need to authenticate the application with your Hue lights API.

* Open the control panel in your browser: `http://your_local_ip:3000`
* Push the button on your Hue Bridge
* You now have 30 seconds to run back to your browser and reload the page

###Options for Deploying

Now that you've tested the app, you may want to set it up to run all the time. There are a couple of options for this.

First thing's first. The app needs to live on the same LAN as the lights it will be controlling. As the name implies, I'm running mine on a Raspberry Pi so it can be always on and out of the way.

Next, you could [do a proper production deployment](https://www.digitalocean.com/community/tutorials/how-to-deploy-a-meteor-js-application-on-ubuntu-14-04-with-nginx).

Or (much easier) since it will only ever be accessed over the local network, just run it in the background, using the dev server: `meteor &`
