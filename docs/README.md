# Live site (GitHub Pages)

`index.html` in this folder is the CV/portfolio website, ready to serve directly from GitHub Pages.

## One-time setup (do this once)

1. Go to this repo on GitHub → **Settings** → **Pages** (left sidebar).
2. Under **Build and deployment** → **Source**, choose **Deploy from a branch**.
3. Under **Branch**, choose `main` and folder **`/docs`**, then **Save**.
4. Wait a minute or two — GitHub will show the live URL at the top of that same Pages settings page, typically:

   `https://benahshikanga.github.io/My-Portfolio/`

That's it — no further setup needed. Any future push to `docs/index.html` on `main` automatically updates the live site.

## Updating the site later

Edit `docs/index.html` directly (it's a single self-contained file — HTML, CSS, and JS all in one) and push to `main`.
The live site updates automatically within a minute or two of the push.
