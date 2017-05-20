# Glayu

[![Managed with Taiga.io](https://img.shields.io/badge/managed%20with-TAIGA.io-709f14.svg)](https://tree.taiga.io/project/pablomartinez-glayu/ "Managed with Taiga.io")

## Overview

Glayu is a static site generator focused on mid-sized sites, that generate content frequently and have to deal with multiple categories, like magazines and newspapers.

Design Concerns:

* __Divide and ~~conquer~~ build:__ Glayu sites are splitted into multiple directories that can be generated separately.
* __Fast generation:__ Gayu sites are generated concurrently taking advance of Elixir’s / Erlang VM capabilities.
* __Just a static site generator:__ Glayu is focused on creating HTML pages, different building pipelines are required to handle tasks like image generation or javascript and style sheets compilation.

## Installation

### Escript

Glayu is distributed as an Escript executable, before running it, you need [Erlang](http://www.erlang.org/) installed on your computer. You can find the latest Erlang releases under the [Erlang downloads page](http://www.erlang.org/downloads).

Once you have installed Erlang. Download the latest [glayu binary]() from the releases section and add it to your PATH. Now you can invoke the `glayu` command.

### Build From Source

Before building Glayu you need [Elixir](http://elixir-lang.org/) installed on your computer. A detailed installation guide is available on the [Elixir web page] (http://elixir-lang.org/install.html).

Once you have installed Elixir:

Clone the Glayu repo: 

```console
$ git clone https://github.com/pmartinezalvarez/glayu.git`
```

Get the project dependencies: 

```console
$ mix deps.get
```

Generate the glayu Escript executable: 

```console
$ mix escript.build
```

Under the glayu root directory you will find the `glayu` binary file.
	
## Site Setup

After installing Glayu, run the `init` command to generate a Glayu site in the target `<folder>`.

```console
$ glayu init <folder>
```

You project folder will look like:

```
.
├── _config.yml
├── public
├── source
|   ├── _drafts
|   └── _posts
└── themes
```

### _config.yml

Site configuration file.

```yml
# Glayu Configuration

# Site
title: A brand new static site              # Site Title

# URL
permalink: categories/year/month/day/title  # Permalink format

# Directories
source_dir: source                          # Source folder
public_dir: public                          # Destination folder

# Theme
theme: glayu-times                          # Selected Theme under themes dir
theme_uri: https://github.com/pmartinezalvarez/glayu-times-theme/archive/master.zip
```

### source

The source folder. This is were your site content resides. All Markdown files under the `source` folder will be processed and the generated HTML put into the `public` folder, except the files inside the `_drafts` folder, that will be ignored.

### themes

Themes folder. Glayu will generate the final site combining the site contents with the theme selected on the configuration file.

The default theme is [The Glayu Times](https://github.com/pmartinezalvarez/glayu-times-theme)

## Writing

You can create a new post or page using the `new` command:

```console
glayu new [layout] <title>
```

`new` command supported layouts are __post__ and __page__

### Drafts and Posts

To create your first post run:

```console
$ glayu new post "My First Glayu Post"
```

It will generate the Markdown file `source/_drafts/my-first-glayu-post.md`. Glayu slugifies the post title and uses it as filename.

All new posts are _drafts_, and will be saved into the `source/_drafts` directory. This directory will be skipped during site builds.

#### Front-matter

The new Markdown file will look like:

```yml
---
title: My First Glayu Post
date: 2017-05-18 06:45:22
author:
featured_image:
score: 10
summary:
categories:
- Software
- Static Sites
tags:
- Glayu
- Elixir
---
A new Glayu post
```

At the beginning of the file, delimited by three dashes, is the __Front-matter__. It is a block of YAML used to configure your article variables. Just below is the post content.

Variable | Description | Default
------------ | ------------- | -------------
__`title*`__ | Article Title
__`date*`__ | Publication Date | Creation Date
__`categories*`__ | Article Categories (top-down) | Software, Static Sites (demo)
`author` | Article Author |
`featured_image` | Article main image |
`score` | Article priority, used by themes to render top stories (the higher the better) | 10
`summary ` | Article summary, if not present the first content paragraph will be used |
`tags` | Article Tags | Glayu, Elixir (demo)

__`*`__ Required variables.

All new variables added to the Front-matter will be processed and includes on the page scope.

#### Publishing a Draft

Once your post is ready, you can move it to the `source/_posts` folder using the `publish` command:

```console
$ glayu publish my-first-glayu-post.md
```

The Markdown file will be moved from `source/_drafts/my-first-glayu-post.md` to `source/_posts/software/static-sites/2017/05/18/my-first-glayu-post.md`. The destination path will be calculated using the `permalink` value defined in `_config.yml`: 

```yml
permalink: categories/year/month/day/title
```

The Markdown will be rendered on next site build.

### Pages

All pages are generated under the `source` directory and will be processed on next build.

By default, a page __Front-matter__ includes:

Variable | Description | Default
------------ | ------------- | -------------
__`title*`__ | Article Title
__`date*`__ | Publication Date | Creation Date 

__`*`__ Required variables.

## Site Generation

You can generate your site using the `build` command:

```console
$ glayu build
```

Will generate the full site.

If you want to render only part of your posts you can pass a regular expression to the `build` command. Supported regular expressions are based on PCRE (Perl Compatible Regular Expressions):

```console
$ glayu build _posts/software/.*2017/
```

will render the posts under `software` published on 2017.

## Commands

### init

```console
glayu init [folder]
```

Initializes the website.

If no `folder` is provided, the website will be configured in the current directory.

If the destination folder exists and contains a `_config.yml` file, this configuration file will be used to initialize the site.

##### Arguments
Argument | Description
------------ | -------------
`folder` | Website destination folder. If the destination folder doesn't exists the full path to it will be created.

##### Examples

```console
$ mkdir my-glayu-site
$ cd my-glayu-site
$ glayu init
```
or

```console
$ glayu init ./my-glayu-site
```

### new

```console
glayu new [layout] <title>
```

Creates a new post or page. 

All new posts are considered drafts and will placed under the `source/_drafts` directory, this directory will be skipped during a site build. When a post is ready it can be published using the `publish` command.

All pages are placed under the `source` directory, and are rendered during a site build.

##### Arguments
Argument | Description
------------ | -------------
`[layout]` | __post__ or __page__. If no layout is provided, Glayu will use the post layout.
`<title>` | Article title. If the title contains spaces, surround it with quotation marks.

##### Examples

```console
$ glayu new "My First Glayu Post"
```

### publish

```console
glayu publish <filename>
```

Publishes a draft.

The markdown file will be moved from the `source/_drafts` directory to a directory under `source/_posts` following the permalik definition provided in `_config.yml`.

##### Arguments
Argument | Description
------------ | -------------
`<filename>` | Markdown source file. The file name or the file path can be provided.

##### Examples

```console
$ glayu publish my-first-glayu-post.md
```

or

```console
glayu publish {site_dir}/source/_drafts/my-first-glayu-post.md
```

### build

```console
glayu build [-chp] [regex]
```

Generates the static files.

##### Arguments

Argument | Description
------------ | -------------
`[regex]` | If provided, only the pages under the directories matching the regex will be generated. The regular expression is based on PCRE (Perl Compatible Regular Expressions)

##### Options

If one of the `-chp` options is provided the building process will consider only the resource types provided on the options.

Option | Description
------------ | -------------
`[-c, --categories]` | Adds category pages to the building pipeline.
`[-h, --home]` | Adds home page to the building pipeline.
`[-p, --pages]` | Adds post and pages to the building pipeline.


##### Examples

```console
$ glayu build 
```
generates the full site

```console
$ glayu build _posts/business/.*2017/.*
```

generates all 2017 business pages

### help

```console
glayu help [command]
```

Displays help.

If `command is not specified, all of the commands supported by Glayu are listed.

##### Arguments

Argument | Description
------------ | -------------
`[command]` | Displays help information on that command.


## Customization

### Permalinks

You can specify the permalinks for your site in `_config.yml`

The default value is: 

`categories/year/month/day/title`

Supported variables are:

Variable | Description
------------ | -------------
categories | Categories extracted from the post __Front-matter__
year | Year, extracted from post publication date (4-digits)
month | Month, extracted from post publication date (2-digits)
day | Day of the month, extracted from post publication date (2-digits)
title | Slugified post title.

### Themes

The active theme is defined by the `theme` variable on your site configuration file `_config.yml`.

The default value is `glayu-times`, it enables [The Glayu Times](https://github.com/pmartinezalvarez/glayu-times-theme) theme, downloaded to the `themes/glayu-times` folder after running `init`.

If the variable `theme_uri` is defined, the `init` command will try to download the selected theme from the specified uri.

To create a new theme, create a directory under the `themes` folder. The directory name is the value you will have to provide on `_config.yml` to activate your theme.

A theme should have the following structure:

```
.
├── _layouts
├── _partials
└── assets
```

#### _layouts

This folder contains the theme’s template files, which define the appearance of your website. Glayu uses the [Embedded Elixir (EEx)](https://hexdocs.pm/eex/EEx.html) templates engine.

#### _partials

This folder contains components that are shared between your templates.

#### assets

Compiled assets, this directory will be copied to the public site directory on each build.

### Templates

Templates are stored under the `_layouts` folder and define the presentation of your site. The table below shows the corresponding template for every available page.

Template | Page
------------ | -------------
`layout.eex` | Global layout common to all pages
`home.eex` | site home
`post.eex` | posts
`page.eex` | pages
`category.eex` | category home

#### Global Layout

The global layout provides a structure shared by all pages. It should contain a `<%= @inner %>` directive that will be replaced with the content of the corresponding template, depending on the page type.

##### Example

```html
<!DOCTYPE html>
<html>
  <head>
    <title><%= @page.title%></title>
    <!-- Style sheets -->
  </head>
  <body>
    <%= @inner %>
    <!-- Scripts -->
  </body>
</html>
```

#### Partials

Partials are a tool to share components between templates. Typical use cases are page sections like the header, footer or navbars.

All `.eex` files placed under the `_partials` folder will be compiled and can be required inside any template using the directive:

```html
<%= partial "<partialname>" %>
```

Before using the `partial` directive you have to declare that you want tu use the `Glayu.EEx` module:

```html
<% use Glayu.EEx %>
```

##### Example

`_partials/header.eex`

```html
<h1 id="header"><%= @page.title%></h1>
```

`_layouts/home.eex`

```html
<% use Glayu.EEx %>
<%= partial "header" %>
<div>
<!-- page content ->
</div>
```

Will be handled as:

```html
<h1 id="header"><%= @page.title%></h1>
<div>
<!-- page content ->
</div>
```

### Variables

#### Site Variables

Variable | Description | Type
------------ | ------------- | -------------
`@site.title` | Site title | String

#### Page Common Variables

Variable | Description | Type
------------ | ------------- | -------------
`@page.title` | Page Title | `String`
`@page.layout` | Page layout `:post`, `:page`, `:category` or `:home` | `atom`
`@page.type` | Page type `:draft`, `:post`, `:page`, `:category` or `:home` | `atom`
`@page.path` | Page relative URL path | `String`

All extra __Front-matter__ variables will be added to the `@page` scope.

#### Post and Page Common Variables

Variable | Description | Type
------------ | ------------- | -------------
`@page.date` | Page publication date | [`DateTime`](https://hexdocs.pm/elixir/DateTime.html)
`@page.source` | Source markdown file path | `String`
`@page.raw` | Content as Markdown | `String`
`@page.content` | Content as HTML | `String`

#### Post Specific Variables

Variable | Description | Type
------------ | ------------- | -------------
`@page.categories` | Post categories. It is a `List` where each item is a `Map` including following fields: `keys`, `name`, `path`. The `keys` identify the category and are required to retrieve extra information like the category latest posts. `name` is the category name. And `path` is the relative URL to the category home page. | `List`
`@page.summary` | Post summary (HTML) | `String`

Optional Variables

Variable | Description | Type
------------ | ------------- | -------------
`@page.tags` | Post tags list.  | `List`
`author` | Post author | `String`
`featured_image` | Featured image | `String`
`score` | Page relevance score | `String`

#### Category Page Specific Variables

Variable | Description | Type
------------ | ------------- | -------------
`@page.category` |  Current category | `Map`
`@page.category.keys` | Category Keys | `List`
`@page.category.name` | Category Name | `String`
`@page.category.path` | Relative URL path, the same value as `@page.path` | `String`
`@page.category.parent` | Parent category on the site hierarchy, includes the fields: `keys`, `name` and `path` | `Map`


### Helpers

The `Glayu.EEx` module includes a set of helpers that can be invoked in your templates after include the `<% use Glayu.EEx %>` directive.

#### Categories

```
categories()
```

Returns the list of first level categories of the site. Each category is a `Map` containing following fields:

Field | Description | Type
------------ | ------------- | -------------
`keys` | Category keys | `List`
`name` | Category name | `String`
`path` | Category home page relative URL | `String`

#### Subcategories

```elixir
subcategories(<category_keys>)
```

return the list of subcategories of a given category.

##### Arguments

Field | Description
------------ | -------------
`keys` | Parent category keys 

##### Examples

Rendering the sub-categories menu on a category page.

```html
<nav id="mini-navigation">
  <ul class="nav navbar-nav">
  <%= for subcategory <- subcategories(@page.category.keys) do %>
  <li><a href="<%= subcategory.path %>"><%= subcategory.name %></a></li>
  <% end %>
  </ul>
</nav>
```

#### Latest Posts

```elixir
posts([limit: <num_posts>, sort_fn: <sort_fn>])
```

List the latest site posts.

##### Arguments

Argument | Description
------------ | -------------
`<num_posts>` | Number of post to be retrieved (max. 100).
`<sort_fn>` | Sorting function (applied over the last 100)

##### Examples

Displaying most relevant post of the site.

```html
<%= for post <- posts([limit: 10, sort_fn: &(&1.score > &2.score)]) do %>
<div class="article">
  <%= if post[:featured_image] do %>
  <img src="<%= post.featured_image %>" alt="featured image">
  <% end %>
  <h2><a href="<%= post.path %>"><%= post.title %></a></h2>
  <div><%= post.summary %></div>
</div>
<% end %>
```
#### Latest Category Posts

```elixir
posts(<category_keys>, [limit: <num_posts>, sort_fn: <sort_fn>])
```

works similar but limiting the returned post to a specific category.

#### Date Formatter

```elixir
Date.format(<date>, <strftime_format>)
```

Formats an article date.

##### Arguments

Argument | Description
------------ | -------------
`<date>` | Date to be formated
`<strftime>` | [strftime](http://strftime.org/) compatible expression, that defines the date formal.

##### Examples

```html
<%= Date.format(post.date, "%Y-%m-%d %H:%M") %>
```

Will render a date formated like: `2017-05-18 06:45:22`

#### Current Date

```elixir
Date.now(<strftime_format>)
```

Formats current date and time.
  