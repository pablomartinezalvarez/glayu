[![glayu](https://cdn.rawgit.com/pmartinezalvarez/glayu/a3626e17/glayu.svg)](http://www.glayu.com)


[![Build Status](https://travis-ci.org/pmartinezalvarez/glayu.svg?branch=master)](https://travis-ci.org/pmartinezalvarez/glayu)

## What is Glayu?
Glayu is a static site generator for mid-sized sites that generate content frequently and have to deal with multiple categories, like magazines and newspapers.

What makes Glayu different from other static site generators is the way it structures the source folder: when you publish an article using Glayu, the markdown file is placed inside a subfolder of the `source` directory following the permalink definition.

With the default permalink definition `categories/year/month/day/title`  your `source` and `public` directories will look like:

![Workflow](http://d33wubrfki0l68.cloudfront.net/461058aadfeee3aaff45fe46765498c74f7c5edc/62dee/assets/images/overview/workflow.png)

The motivation of this `source` folder organization is to split the site content in smaller units that can be managed independently. Glayu takes advance of this folder organization to enable the concurrent and partial generation of the site. 

In the previous example a complete build of the site will handle the `/source/_posts/world/2017/07/11` and `/source/_posts/us/2017/11`  folders concurrently. 

Glayu enables the partial generation of the site by using regular expressions, so if you will be interested in only generate the `world` articles you could use the `build` command like this:
   
```console
$ glayu build _posts/world*
```

## Features

* Partial site generation.
* Well organized source folder.
* Fast, thanks to [Elixir](https://elixir-lang.org/) and the [Erlang VM](http://www.erlang.org/).
* Themes support.
* Partials support.

## Quick Start

Pre-requisites: [Erlang](http://www.erlang.org/downloads) installed on your machine.

Get the latest [Glayu binary](https://github.com/pmartinezalvarez/glayu/raw/master/apps/glayu/glayu), grant execution permissions if needed, and add it to your `PATH`

Init the site.

```console
$ glayu init glayu_site
🐦 Your Glayu site has been created at ${PATH_TO_SITE}/glayu_site
```

Create your first post.

```console
$ cd ./glayu_site
$ glayu new "My First Glayu Article"
🐦 Post created at ${PATH_TO_SITE}/glayu_site/source/_drafts/my-first-glayu-article.md
```

Publish your post.

```console
$ glayu publish my-first-glayu-article.md
🐦 Draft published to ${PATH_TO_SITE}/glayu_site/source/_posts/software/static-sites/2017/07/11/my-first-glayu-article.md
```

Build the site.

```console
$ glayu build
✓ Site pages generated.
└── 1 pages generated.
✓ Category pages generated.
└── 2 category pages generated.
✓ Home page generated.
✓ Site assets copied from theme folder to public folder.
└── 20 files copied.
🐦 Site Generated Successfully.
```
The site pages are generated under `../glayu_site/public`

## Documentation Site

Check the [docs](http://www.glayu.com/overview).

## Themes

[Glayu Times](https://github.com/pmartinezalvarez/glayu-times-theme)

[Glayu Bootswatch](https://github.com/gnucifer/glayu-bootswatch) by [David Gustafsson](https://github.com/gnucifer)

## Source Code Organization

Glayu is an Elixir umbrella project including following applications:

Application | Description
------------ | -------------
`glayu` | `glayu` escript binary generation
`glayu_core` | main Glayu logic
`glayu_build` | `SiteTree` and site pages rendering logic
`glayu_preview_server` | preview server

## License

This project is available under the MIT license.
  