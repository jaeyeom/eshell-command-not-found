# eshell-command-not-found

## Build / Test

- `make build` to byte-compile, `make test` to run tests, `make lint` and `make checkdoc` for linting

## Architecture

- This is an **Emacs Lisp** package
- All public symbols must use the `eshell-command-not-found-` prefix; internal/private helpers use `eshell-command-not-found--` (double dash) — MELPA reviewers enforce this
- Only autoload user-facing entry points (`defcustom`, `define-minor-mode`); do not autoload internal functions

## Conventions

- **MELPA compliance**: header attributes (Version, Package-Requires, URL, Keywords) must stay parsable by `version-to-list`. Bump Version manually — there is no auto-versioning from git tags
- **Lexical binding** is required (`-*- lexical-binding: t; -*-` in file header)
- Use `#'` (sharp-quote) for function references in hooks — commit 9626730 fixed this project-wide

## Gotchas

- **`%` in shell output**: The `eshell-command-not-found` function passes shell output through `error`, which interprets `%` as format specifiers. The output must be wrapped with `"%s"` to avoid crashes. This was a real bug fixed in commit 0efda98
- **command-not-found binary required**: The package only works on systems where a `command-not-found` executable exists (Linux distros, Termux). It does not work on macOS natively
- **Arch Linux instructions are untested**: The README documents a `pkgfile` wrapper script for Arch, but this has never been verified — treat it as best-effort guidance
- **Tests mock the binary**: Tests create a temporary shell script instead of requiring the real `command-not-found`, so `make test` works on any system with Emacs installed
- **`eshell-alternate-command-hook`**: This is an obscure eshell hook (not widely documented) that fires when a command is not found. The mode adds/removes from this hook — do not use `eshell-command-not-found-hook` or similar names
