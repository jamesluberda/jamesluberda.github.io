---
layout: post
title:  "Setting Up for Jekyll and My Personal GitHub Page"
tags: [ programming ] 
---
After having largely ignored my personal GitHub page since initially configuring it, I finally decided to set up a proper workflow for maintenance and updates. I was partly inspired by my renewed efforts to utilize my iPad Pro for development stuff, and in particular because I wanted to take advantage of the markdown editor (among other things) [Editorial](https://itunes.apple.com/us/app/editorial/id673907758), which I also run on my older iPad (3rd gen) and my iPhone, increasing the likelihood that I will maintain the site, as I can do so with whatever device I have at hand with my preferred editor.

In brief, my configuration is as follows:

* My primary laptop, running Jekyll locally to generate site previews prior to uploading to GitHub
* Dropbox, to make the content that Jekyll will run against available to my other devices
* Editorial, running on my iDevices, sync'd to Dropbox, to generate and edit my content

To begin with, I needed to install Jekyll. Jekyll is Ruby-based, and requires a version of Ruby >=2.1.0. My environment is CentOS 7, which ships with 2.0.0. There are [various ways](https://www.ruby-lang.org/en/downloads/) of going about getting a version of Ruby compatible with Jekyll, and I opted to go with the [RVM-based solution](http://rvm.io/) after my attempt at building from source failed (apparently a common problem). For those familiar with [perlbrew](https://perlbrew.pl/), it seems to provide similar functionality as the latter does for Perl, in terms of managing multiple installations of the same language and attendant libraries. I ended up installing Ruby 2.4.1. I then followed the rest of the install steps [that GitHub provides](https://help.github.com/articles/setting-up-your-github-pages-site-locally-with-jekyll/) to install Jekyll and the GitHub Pages gem to complete my setup, including creating my local copy of my site repo.

Next I needed to sync my markdown editor, Editorial, with the local repo. Editorial, when configured to sync with Dropbox, by default uses /Apps/Editorial as its path in the Dropbox folder. Initially, I had recreated there two of the site's folders for the content I planned on working on in Editorial,`_posts` and `_drafts`, and then created symbolic links to those folders in my site's working directory. I then learned the hard way, after my first push, which resulted in a Jekyll build failure on GitHub, that git won't, and can't be forced to, follow symlinks (apparently it did at one point, but no more). I get this, I suppose, and (one) solution was simple: instead of storing the content in Dropbox and linking to it (where I started), I moved the content to my working directory and created links back to it under the Dropbox Editorial folder.

I then ran into another problem, which was getting the GitHub site metadata (the `site.github.*` variables such as `site.github.is_user_page`) populated for my local Jekyll install. I believe my mistake was doing anything at all to the `_config.yml` file with respect to enabling this. I had come across various sources that, variously, suggested adding one or more of the following to my config file:

```
repository: jamesluberda/jamesluberda.github.io
```

```
github: [metadata]
```

```
plugins:
	 - jekyll-github-metadata
```
As it turned out, I needn't have added anything, as it was only after I removed them altogether that my `site.github.*` variables began being populated. The key was that all that was needed to get my metadata was for my local repo's origin to be correctly set (which it was), and everything went swimmingly after I removed the above interference.

With my configuration complete, I opened port 4000 (Jekyll's default) and began running Jekyll via `bundle exec jekyll serve` with the additional directives `--host 0.0.0.0`, `--drafts`,  and `--livereload`, and started creating new content (this being the start)

A few notes:

The `--drafts` directive causes Jekyll to process the content in the `_drafts` folder (one of the two folders I mentioned earlier sync'd in Dropbox), which, without this directive, would otherwise be ignored by Jekyll. This is one particular benefit to a local install, because you can develop your draft content locally, preview it, and maintain it in your repo across pushes, as GitHub generates your site without this option. 

As for `--livereload`, it is first worth noting that I found it required an additional port open, 35729. It's a very nice feature on top of Jekyll's default automatic site rebuild when files change, as it forces the browser to reload as well, showing me the changes almost immediately on my other iPad, which I have open to the local copy of the site. However, I ended up getting intermittent  livereload errors (page not found) and partial content updates (i.e. mid-edit). As it turns out, Dropbox sync causes multiple filesystem-level changes for each updated file it syncs, and this appears to cause multiple auto-regenerations to clobber each other. I hacked a solution, basically taking advantage of a delay option in the file-change notification module, which seems to be working.

