# Home #

My personal site. A little Sinatra-based blogging engine that renders Markdown
notes through Haml templates. It is built to **static HTML** and served from
GitHub Pages — there is no running server in production.

## Writing a post

Add a Markdown file under `md/notes/`, with simple YAML-ish frontmatter:

```
title: Cornwall
date: 10-08-2020 23:29:40 UTC
tags: travel

...body...
```

Commit and push to `master`. GitHub Actions rebuilds and deploys automatically
(see `.github/workflows/deploy.yml`).

## Building locally

```
bundle install
bundle exec ruby build.rb        # renders the whole site into ./build
bundle exec ruby tasks/preview.rb   # preview at http://localhost:8000
```

`build.rb` boots the Sinatra app in-process and freezes every page to flat HTML.

## Assets

CSS/JS are precompiled and committed under `public/assets/`. They only need
regenerating when you change `assets/stylesheets` or `assets/javascripts`:

```
bundle exec ruby tasks/compile_assets.rb
```
