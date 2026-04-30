# AGENTS.md

## Scope and source of truth
- Honor ignore/control files first: respect `.gitignore`, `.aiignore`, and other `*ignore` rules (for example `.dockerignore`) when selecting files to read, modify, or generate unless the user explicitly overrides this.
- This repository builds and publishes custom PHP container images to GHCR (`ghcr.io/toshy/php`) and publishes docs to GitHub Pages.
- Existing AI guidance discovered from the requested glob search: `README.md` only.
- Treat build/workflow/doc config files below as canonical behavior.

## Architecture map (read in this order)
- `docker-bake.hcl` is the release matrix brain: PHP versions, flavor/OS compatibility, targets, tags, and OCI labels are generated here.
- `Dockerfile` defines 5 stages: `common` -> `base`, `ffmpeg`, `otel`, `otel-ffmpeg`.
- `common` installs shared binaries/extensions; each target stage adds only its delta.
- Build context `php-base` is injected from upstream `php:<version>-<flavor>-<os>` via bake contexts (not a local FROM alias).
- Target names may contain `-` (for example `otel-ffmpeg`); workflow parsing in `release.yml` derives `TARGETS` directly from bake metadata (`.target[].target | unique`) and strips suffixes longest-first — `docker-bake.hcl` remains the single source of truth for the target list.

## Image and tag model you must preserve
- Tag pattern is `<version>-<flavor>-<os>(-<target>)`; `base` is default and has no `-base` suffix.
- `latest` is emitted only for default tuple (`8.5` + `fpm` + `trixie` + `base`) in `docker-bake.hcl`.
- Short tags (for example `fpm-trixie-ffmpeg`) are emitted only for the default PHP version.
- Allowed flavor/OS pairs are constrained by `FLAVOR_OS_MAP`; avoid introducing unsupported combinations.

## CI/CD data flow
- `release.yml` pipeline is `prepare` -> `build` -> `merge`.
- `prepare` resolves concrete upstream patch versions with `skopeo inspect docker://docker.io/library/php:<minor>` and computes the bake matrix.
- `build` runs per-platform builds and pushes by digest.
- `merge` assembles multi-arch manifest lists and assigns final tags from bake metadata.
- `security.yml` performs scheduled Trivy scans of published GHCR tags (`CRITICAL`, ignore unfixed).
- `documentation.yml` builds docs in a container and deploys `/site` to GitHub Pages on `main` pushes.

## Critical local workflows
- List tasks: `task --list`.
- Build docs: `task mkdocs`; live docs: `task mkdocs:live p=8002`.
- Inspect generated bake matrix/tags before CI edits: `task bake:print pv="8.2.30,8.3.30,8.4.17,8.5.2"`.
- Local amd64 bake run: `task bake pv="8.2.30,8.3.30,8.4.17,8.5.2"`.
- Local target vulnerability scan: `task trivy pv="8.5.2-fpm-trixie" t="ffmpeg"`.
- Workflow simulation uses `act` tasks in `Taskfile.yml` (`act:push`, `act:job:prepare`, `act:job:build`, `act:job:merge`).

## Project-specific conventions
- Keep docs and build config synchronized: if extensions/packages/stages change in `Dockerfile`, update `docs/images.md` and `docs/usage.md` examples.
- Default OS is `trixie`; `docs/usage.md` still references `bookworm` as deprecated context.
- Docs tooling is containerized (`ghcr.io/squidfunk/mkdocs-material:9.7`); avoid host-only assumptions.
- Dependency/security automation is GitHub-native (`.github/dependabot.yml` and scheduled workflows).

## Change checklist for agents
- If changing defaults (`DEFAULT_*`, `PHP_VERSIONS`, targets), update `docker-bake.hcl`, `.github/workflows/release.yml`, and docs together.
- If changing target contents, verify tag examples in docs still match real output from `task bake:print`.
- Prefer validating matrix/tag behavior locally before modifying workflow logic.

## Release pipeline gotchas (must preserve)
- `docker-bake.hcl` is the single source of truth for targets. The `prepare` job in `release.yml` derives `TARGETS` from bake metadata via `[.target[].target] | unique` — do NOT reintroduce a hardcoded `TARGETS` env list.
- Bake target naming convention is `php-<ver-with-dashes>-<flavor>-<os>-<target>` and `<target>` may itself contain `-` (for example `otel-ffmpeg`). Always strip the target suffix using the metadata-derived list with a longest-first regex; never use positional `split("-")` indexes on the full target name.
- Per-platform digest artifacts use a `--` (double-hyphen) delimiter: `digest--<variant>--<target>--<platform>`. The merge job's `actions/download-artifact` `pattern` relies on this so that `target=otel` does not glob-match `otel-ffmpeg` artifacts (single `-` would produce a corrupt manifest list). Keep upload names and the download pattern in sync; do not introduce a target name containing `--`.
- When adding a new target: update `Dockerfile` stage and `docker-bake.hcl` `TARGETS` (workflow picks it up automatically), then update `release.yml` (bake `targets:` list, cache-from/to scopes, upload-artifact step), `security.yml` scan matrix, and docs (`docs/usage.md`, `docs/images.md`).

