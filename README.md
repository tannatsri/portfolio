# Personal Portfolio — Hugo Stack

Personal portfolio and blog built with [Hugo](https://gohugo.io/) and the [Stack theme](https://github.com/CaiJimmy/hugo-theme-stack).

## Quick Start

```bash
hugo server --buildDrafts --port 1313
```

Site is now live at http://localhost:1313.

---

## Update Your Personal Details

All personal information lives in one file: [`data/config.yaml`](data/config.yaml)

Edit that file to update your name, bio, skills, experience, and social links. No need to touch anything else.

For the social icons in the sidebar navigation, also update [`config/_default/menu.yaml`](config/_default/menu.yaml).

---

## Adding a New Blog Post

### 1. Create the post

```bash
hugo new content post/your-post-slug/index.md
```

### 2. Edit the front matter

Open `content/post/your-post-slug/index.md` and fill in the header:

```yaml
---
title: "Your Post Title"
description: "A one-line summary shown in listings and SEO."
date: 2024-07-01
categories:
    - Tech        # or Travel
tags:
    - Go          # add as many tags as relevant
image: cover.jpg  # optional — place cover.jpg in the same folder
---
```

### 3. Add a cover image (optional)

Drop a `cover.jpg` into `content/post/your-post-slug/` alongside `index.md`. It appears as the card thumbnail in listings and at the top of the post.

### 4. Write your content

Write in standard Markdown below the front matter. The post is a draft by default — to publish it, remove `draft: true` if present, or just run the server without `--buildDrafts`.

### Categories

| Category | Use for |
|----------|---------|
| `Tech`   | Engineering, programming, tools, tutorials |
| `Travel` | Trip writeups, destination guides, travel tips |

---

## Adding a New Project

Projects live in a single Markdown file: [`content/page/projects/index.md`](content/page/projects/index.md)

Add a new section using this pattern:

```markdown
## Project Name

**Stack:** Go · PostgreSQL · Docker

One or two sentences describing what the project does and why it's interesting.

[GitHub →](https://github.com/tannatsri/your-repo)
```

Paste it above the `*More projects on GitHub*` line at the bottom of the file.

---

## Site Structure

```
.
├── config/_default/
│   ├── hugo.yaml       # site title, baseURL, permalinks
│   ├── params.yaml     # sidebar, widgets, footer year
│   └── menu.yaml       # nav links + social icons
├── data/
│   └── config.yaml     # ← personal details (name, bio, skills, links)
├── content/
│   ├── post/           # blog articles (one folder per post)
│   │   └── post-slug/
│   │       ├── index.md
│   │       └── cover.jpg
│   └── page/
│       ├── about/      # about page
│       ├── projects/   # projects showcase
│       ├── search/     # search page
│       └── archives/   # post archives
├── assets/
│   └── icons/          # custom SVG icons (brand-linkedin.svg lives here)
├── static/
│   └── img/
│       └── avatar.png  # your profile photo
├── themes/stack/       # Hugo Stack theme (git submodule)
├── Dockerfile
└── README.md
```

---

## Build for Production

```bash
hugo build
```

Output goes to `public/`. Deploy the contents of `public/` to any static host (GitHub Pages, Netlify, Cloudflare Pages, etc.).

---

## Docker

Build the image and run it on port 4416:

```bash
# Build
docker build -t portfolio .

# Run
docker run -p 4416:80 portfolio
```

Site is available at http://localhost:4416.

The Dockerfile uses a two-stage build — Hugo compiles the site in the first stage, then the static files are served by `nginx:alpine` in the final image (no Hugo or Go in production).
