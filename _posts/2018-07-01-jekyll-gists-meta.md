---
layout: post
title:  "Developing the Jekyll-Gists-Meta Plugin"
tags: [ programming ] 
---
I just put together my first [Jekyll](https://jekyllrb.com/) plugin (and first gem), [`jekyll-gists-meta`](https://github.com/jamesluberda/jekyll-gists-meta), and although it is a rather trivial bit of work, I thought I'd mention a few things I learned along the way that might prove useful for others working in this area, particularly in getting started with creating a Jekyll plugin.

So this started out as a minor exercise in getting programmatic hold of the metadata for the handful of [gists](https://gist.github.com/discover) I've created, as well as any I create in the future, for use with my Jekyll site (this one here). First, I decided to take the opportunity to learn a bit of GitHub's [GraphQL API v4](https://developer.github.com/v4/), seeing as it would allow me to select the specific metadata I wanted to retrieve (unlike the [REST API v3](https://developer.github.com/v3/), which is more or less a data dump).

Once [I had constructed my query](https://gist.github.com/jamesluberda/d73376298e22e3fc4abbca590b97d5e0), I threw it into a bash script that called out to `curl` to execute it and dump the output to a file in my Jekyll site's `_data` directory. This worked well enough, though it meant that if I wanted to keep my file up-to-date, I would need to either manually execute it or integrate it into my Jekyll workflow via some automated means. I chose the latter, partly because I wanted to learn more about Jekyll's internals, which led to my effort to turn this little shell script into a plugin that I could install, and which would run whenever I started up Jekyll. 

I then began to think about how I wanted my plugin to run. Jekyll's [plugins page](https://jekyllrb.com/docs/plugins/) offers up most of what you need to know about how plugins can be incorporated into Jekyll, as well as how they run. One decision that was made for me off the bat was in fact to make my plugin a gem, because I am using the `github-pages` gem to match the GitHub environment hosting these pages, and which, for security reasons, redefines your site's `plugins_dir` to point to a random string. As a result,  you can't just drop your Ruby code into a `_plugins` directory and incorporate it that way, even locally. Though my plugin still won't run on GitHub, it will run locally if I make it a gem.

So I started by using `bundler` to create the skeleton for my plugin:

```
bundle gem jekyll-gists-meta
```
It very nicely creates a proper directory structure based on your gem's name, along with supporting files, and initializes it as a git repository. You may not necessarily want all of the material it provides, and may decide to organize your directory layout differently, but for general use, it's a solid starting point.

I then looked at how I might hook my code into Jekyll. The documentation lists several types of plugins with corresponding classes that you can use to add functionality, namely, Generators, Converters, Commands, and Tags. In addition, it provides hooks throughout the site-building process. Looking at what my plugin was intended to do, which was to generate a datafile, I had initially started developing it as a Generator. However, an initial test run revealed a problem: the data my plugin was posting to the `_data` directory wasn't available to the pages I intended to populate it with when they rendered, so it appeared I had no data (on a fresh run against an empty directory), and any subsequent runs would always be one data pull behind in terms of what appeared on my site pages.

The problem? My generator was being called *after* the contents of the `data_dir` were already ingested by Jekyll. Here's the order in which Jekyll processing occurs:


```ruby
 64     # Public: Read, process, and write this Site to output.
 65     #
 66     # Returns nothing.
 67     def process
 68       reset
 69       read
 70       generate
 71       render
 72       cleanup
 73       write
 74       print_stats if config["profile"]
 75     end
```

 As is clear from the snippet above, no matter what priority I assigned my generator, it would never run before Jekyll slurped up what it found in the data directory.
  
 So then I reconfigured my code, dropping the Generator class inheritance in favor of Jekyll's hooks, which provide a finer-grained means of having Jekyll execute your code at a particular point in the build process. I put it in as a hook to `after_init`, as that seemed the ideal point at which to run and populate the data directory, well before Jekyll began reading from it.
 
But then I ran into another problem. In order to run my query, I needed to know the user login to put into my query (that is, whose gists I wanted to query). Given that my plugin was intended to run alongside the `github-pages` gem, which also brings in the `github-metadata` gem, I figured the easiest thing to do would be to source my login from that, as it populates the `site.github` variable with all sorts of useful GitHub-related information. Unfortunately, `github-metadata` also uses the `after_init` hook (as I discovered), so if I ran before `github-metadata` could populate `site.github` (which is exactly what happened), I wouldn't have a login, unless specified elsewhere, for my query.

I didn't see anything about priorities for hooks in the documentation, so I poked around the code some more, and found that Jekyll indeed supports priorities for hooks as well as for the other four plugin types:


```ruby
  3 module Jekyll
  4   module Hooks
  5     DEFAULT_PRIORITY = 20
  6 
  7     # compatibility layer for octopress-hooks users
  8     PRIORITY_MAP = {
  9       :low    => 10,
 10       :normal => 20,
 11       :high   => 30,
 12     }.freeze
```

Luckily, `github-metadata` does not explicitly set its priority, and thus is assigned the default of 20 (normal) so by making mine `:low`, I was sure to run after `github-metadata` initialized:

```ruby
Jekyll::Hooks.register :site, :after_init, :priority => :low do |site|
  Jekyll.logger.debug "Jekyll-Gists-Meta:", \
    "Generating gists data file in #{site.config["data_dir"]}"
  Jekyll::Gists::Meta.generate(site)
end
```

And, well, it worked. Again, this is a relatively trivial plugin, so not much to see, but if you like, have a look at the complete code [here](https://github.com/jamesluberda/jekyll-gists-meta). Hopefully this little walkthrough highlighted a few useful things to know for those also  embarking upon Jekyll plugin development.
