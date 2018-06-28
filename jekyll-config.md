---
layout: default
title: "Jekyll Configuration Page"
tags: [ configuration, programming ]
config_excludes: [ categories, collections, data, documents, html_pages, pages,
                   posts, related_posts, static_files, tags ]
config_truncate: 80
description: A simple markdown/Liquid page that iterates through and displays
             the values for first-level configuration elements under the `site`
             variable. Excludes elements listed under `config_excludes` and
             truncates values in excess of `config_truncate` characters, as
             specified in the YAML frontmatter.
---
## Running Jekyll Configuration for site:
## "{{ site.title }}"
**excluding: `{{ page.config_excludes | join: ", " }}`**

{% for config_elm in site.sort %}
  {% unless page.config_excludes contains config_elm[0] %}
    {% capture rawout %}
      {{ config_elm[1] }}
    {% endcapture %}
    {% if rawout.size < page.config_truncate and config_elm[1] != null  %}
{{ config_elm[0] }}: {{ config_elm[1] | strip_newlines }}
    {% elsif rawout.size < page.config_truncate %}
`{{ config_elm[0] }}: {{config_elm[1] | strip_newlines }}`
    {% else %}
**{{ config_elm[0] }}: {{ config_elm[1] | strip_newlines | truncate: 
page.config_truncate }}**
    {% endif %} 
  {% endunless %}
{% endfor %}
