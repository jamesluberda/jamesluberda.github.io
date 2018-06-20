---
layout: post
title: "A Jekyll Site Configuration Settings Page"
tags: [ programming, jekyll ] 
---
I recently wanted to have a way to quickly check how my Jekyll server was ultimately configured after startup, taking into account the fact that some Jekyll-related plugins/gems (specifically, the [`github-pages`](https://github.com/github/pages-gem) gem) have effects on the configuration that are not necessarily immediately clear (i.e., the fact that `github-pages` sets the plugin directory to a random value). Moreover, I wanted a clean view into the configuration settings for troubleshooting their use elsewhere on my site.

The following code generates a simple page (I wanted to limit it to a bit of markdown and a handful of Liquid) that iterates through the site.* variables in alphabetical order. In addition, it is set, via two page variables, to exclude (`config_excludes`) certain configuration values because they tend to be large and not particularly helpful, and to clip those that it doesn't exclude, but that exceed the specified truncation length (`config_truncate`). It also flags those values that are null with `code` styling, and marks truncated entries in **bold**.

It is worth noting that to be able to get a read on the size of a given configuration value, I had to wrangle the variables a bit, partly because Liquid's [`size`](http://shopify.github.io/liquid/filters/size/) function reports values differently for strings (characters) vs. arrays (elements), but also because, as far as I can tell, there's no Liquid function to determine a variable's type. The nice thing is that Liquid's `capture` function can be used to capture the contents of a variable into a string, regardless of type; in the case of an array,  it stringifies it, just as it would if it were placed visibly on the page. As a result, size can be measured consistently across all variables.

`jekyll-config.md`
{% gist 1ed5a627ebaed89c0b943083638ab6bd %}
