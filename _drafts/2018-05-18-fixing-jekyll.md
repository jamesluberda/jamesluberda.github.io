---
layout: post
title:  "Setting Up for Jekyll and My Personal GitHub Page"
tags: [ programming ] 
---
After having largely ignored my personal GitHub page since initially configuring it, I finally decided to set up a proper workflow. I was partly inspired by my renewed efforts to utilize my iPad Pro for development stuff, and in particular because I wanted to take advantage of the markdown editor (among other things) Editorial, which I also run on my older iPad (3rd gen) and my iPhone SE, increasing the likelihood that I will maintain the site, as I can do so with whatever device I have at hand.

In brief, my configuration is as follows:
* My primary laptop, running Jekyll locally to generate site previews prior to uploading to GitHub
* Dropbox, to host the content that  Jekyll will run against, and synchronize it between my local Jekyll install and my other devices
* Editorial, running on my iDevices, sync'd to Dropbox, to generate and edit my content
* Jenkins, though not really necessary, to do an independent site build and test, and push to GitHub

Gave `Jekyll's --livereload` a try, found it requires an additional port open, 35729. It's a very nice feature on top of Jekyll's automatic site rebuild when files change, as it forces the browser to reload as well, showing me the changes immediately on my other iPad, which I have open to the local copy of the site. However, I have ended up getting intermittent  livereload errors (page not found) and partial content updates (i.e. mid-edit). I'm guessing it's a timing issue with Jekyll's rebuild. In any case, it's nice when it works, and not a big deal to manually reload the page when it doesn't.

I also learned the hard way that git won't, and can't be forced to, follow symlinks (apparently it did at one point, but no more). I get this, I suppose, and the solution was simple: instead of storing the content in Dropbox and linking to it (where I started), I moved the content to my working directory and linked to Dropbox.
