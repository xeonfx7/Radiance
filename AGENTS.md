# Radiance AI coding instructions

This repository is a customized Shopify Horizon theme. The main goal is to keep Radiance customizations easy to carry forward when pulling updates from Shopify's Horizon GitHub repository.

## Highest priority for code changes

Avoid touching core Horizon files unless the user explicitly asks for it or there is no practical update-safe alternative.

The preferred customization pattern is:

- create custom blocks as `blocks/rad_*.liquid`
- create custom sections as `sections/rad_*.liquid`
- create custom snippets as `snippets/rad_*.liquid`
- create alternate templates such as `templates/product.rad_ccshirt.json`
- wire custom behavior into alternate templates instead of changing default templates

The default Shopify/Horizon files should remain as close to upstream as possible.

## Files to avoid editing

Do not edit these unless necessary:

- `templates/product.json`
- `sections/product-information.liquid`
- `snippets/product-information-content.liquid`
- core header files
- core cart files
- global theme assets shared by many templates
- files that are likely to receive frequent upstream Horizon changes

If one of these files must be changed, keep the diff minimal and explain why no `rad_` alternative was practical.

## Product template strategy

Use alternate product templates for custom product families.

For Comfort Colors shirt products, use:

- `templates/product.rad_ccshirt.json`
- custom blocks/sections/snippets prefixed with `rad_`

Do not put Comfort Colors-specific layout, breadcrumb, after-cart content, size chart logic, or product styling into the default `templates/product.json` unless the user explicitly requests it.

## Preview strategy

Before suggesting that changes are ready, validate and preview them without publishing:

```bash
shopify theme check
shopify theme dev
```

Preview alternate product templates with the `view` query parameter:

```text
http://127.0.0.1:9292/products/YOUR-PRODUCT-HANDLE?view=rad_ccshirt
```

Do not require committing before local preview.

## Horizon update strategy

Before pulling or merging Horizon updates, check the worktree:

```bash
git status --short
```

Fetch upstream updates:

```bash
git fetch --all --prune
```

Prefer merging Horizon updates in a separate branch first:

```bash
git switch -c codex/horizon-update-YYYYMMDD
git merge upstream/main
```

After merging, run:

```bash
shopify theme check
```

Then preview both:

```text
http://127.0.0.1:9292/products/YOUR-PRODUCT-HANDLE
http://127.0.0.1:9292/products/YOUR-PRODUCT-HANDLE?view=rad_ccshirt
```

Only merge back to `production` after the updated theme has been reviewed.

## Conflict-avoidance checklist

For every requested change, first ask:

1. Can this be done with Shopify Admin/theme editor settings?
2. Can this be done with an alternate template?
3. Can this be done with a new `rad_` block, section, or snippet?
4. Can this be scoped to only the product family/template that needs it?

Only edit shared Horizon files after these options are not enough.

## Documentation

Keep developer workflow notes in `README.dev.md`. If a new custom pattern is introduced, update that file so future work follows the same update-safe approach.
