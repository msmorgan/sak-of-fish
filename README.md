# sak-of-fish

Swiss Army knife of fish-shell utility functions.

Personal collection, with fisher-compatible layout.

## Install (fisher)

```fish
fisher install msmorgan/sak-of-fish
```

## Local dev

Link the `sak_dev.fish` into your `.config/fish/conf.d`, or run:

```fish
fish sak_dev.fish link # To create the symlink.
fish sak_dev.fish unlink # To delete it.
```

On every new fish shell it prepends the repo's `functions/` and `completions/`
directories and to `$fish_function_path` and `$fish_complete_path`, so edits in
the repo take effect immediately.

