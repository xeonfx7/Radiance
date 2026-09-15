# Radiance theme development flow

This repo is a customized Shopify Horizon theme. Keep custom work isolated in `rad_` files/templates whenever possible so Horizon updates can be pulled with fewer conflicts.

## Current remote setup

- `origin`: Radiance theme repo
- `upstream`: Shopify Horizon repo
- main working branch used here: `production`

Check anytime:

```bash
git remote -v
git branch --show-current
git status --short
```

## Local preview without publishing

Use Shopify's development theme preview:

```bash
shopify theme dev
```

This uploads your current local files to a hidden development theme and prints preview/theme-editor links. Keep the terminal running while testing.

Preview the custom Comfort Colors shirt template without assigning it live:

```text
http://127.0.0.1:9292/products/YOUR-PRODUCT-HANDLE?view=rad_ccshirt
```

Example:

```text
http://127.0.0.1:9292/products/out-of-breath-t-shirt?view=rad_ccshirt
```

Why this works:

- The file `templates/product.rad_ccshirt.json` creates the alternate product template.
- The suffix is `rad_ccshirt`.
- The `?view=rad_ccshirt` URL parameter renders that template for preview only.
- You do not need to assign the template in Shopify Admin just to preview it.
- You do not need to commit or publish before using `shopify theme dev`.

## Validate before commit

Run:

```bash
shopify theme check
```

Known existing Horizon warnings may appear, for example the header setting count and divider doc params. Treat new errors/warnings in `rad_` files as things to fix before commit.

Also compare the custom product template against the default product template:

```bash
diff -u templates/product.json templates/product.rad_ccshirt.json
```

The expected difference should mainly be:

- the `rad_breadcrumbs` section
- the `rad_ccshirt_meta` block
- the `rad_ccshirt_after_cart` block
- any other intentional `rad_` customization

## Commit custom work

After preview and theme check pass:

```bash
git status --short
git add AGENTS.md
git add README.dev.md
git add blocks/rad_ccshirt_meta.liquid
git add blocks/rad_ccshirt_after_cart.liquid
git add sections/rad_breadcrumbs.liquid
git add snippets/rad_breadcrumbs.liquid
git add templates/product.rad_ccshirt.json
git add templates/product.rad_shirt.json
git commit -m "Add rad ccshirt product template"
```

Note: `templates/product.rad_shirt.json` is added above because it was renamed/replaced by `templates/product.rad_ccshirt.json`; Git needs to record the deletion.

## Safe Horizon update flow

Before pulling updates, make sure your work is committed or intentionally stashed:

```bash
git status --short
```

Fetch both your repo and Shopify Horizon:

```bash
git fetch --all --prune
```

Bring in updates already pushed to your Radiance repo:

```bash
git switch production
git pull --ff-only origin production
```

Check whether the latest fetched Horizon commit is already included:

```bash
git merge-base --is-ancestor upstream/main production && echo "Horizon is included" || echo "Horizon has newer commits"
```

If Horizon is already included, no direct upstream merge is needed.

If Horizon has newer commits, merge it in a separate update branch first:

```bash
git switch -c codex/horizon-update-YYYYMMDD
git merge upstream/main
```

Then resolve any conflicts, validate, and preview:

```bash
shopify theme check
shopify theme dev
```

Use the local preview URLs to test:

```text
http://127.0.0.1:9292/products/YOUR-PRODUCT-HANDLE
http://127.0.0.1:9292/products/YOUR-PRODUCT-HANDLE?view=rad_ccshirt
```

Only merge the update branch back into `production` after preview looks correct.

## Update-safe customization rule

Prefer this pattern:

- add new custom blocks in `blocks/rad_*.liquid`
- add new custom sections in `sections/rad_*.liquid`
- add custom snippets in `snippets/rad_*.liquid`
- add custom templates like `templates/product.rad_ccshirt.json`

Avoid editing shared Horizon files unless there is no practical alternative:

- `sections/product-information.liquid`
- `snippets/product-information-content.liquid`
- `templates/product.json`
- core header/cart/theme files

If a shared Horizon file must be edited, keep the diff tiny and clearly comment the reason so future Horizon merges are easier to review.
