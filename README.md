# Home #

My personal site. A small static site generator that renders Markdown notes
through Haml templates. It is built to **static HTML** and served from
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

### Adding photos

Put a `<div class="gallery">` in the note's Markdown, drop full-resolution
`.jpg` photos into `assets/images/<note-slug>/`, then:

```
bundle exec ruby tasks/compress_images.rb   # needs ImageMagick
```

This writes a `<name>-compress.jpg` next to each photo. Commit the variants
and delete the originals — only `-compress.jpg` files are deployed. The
gallery picks up every variant in the folder automatically, rendered with
native lazy loading (`loading="lazy"`).

## Building locally

```
bundle install
bundle exec ruby build.rb        # renders the whole site into ./build
bundle exec ruby tasks/preview.rb   # preview at http://localhost:8000
```

`build.rb` renders each page (one per Markdown note, plus the index/about/
contact/posts pages) through the Haml templates in `app/views` and writes flat
HTML files. `lib/renderer.rb` is the whole rendering engine.

## Assets

CSS/JS are precompiled and committed under `public/assets/`. They only need
regenerating when you change `assets/stylesheets` or `assets/javascripts`:

```
bundle exec ruby tasks/compile_assets.rb
```
