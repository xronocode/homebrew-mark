# homebrew-mark

[![ko-fi](https://img.shields.io/badge/ko--fi-support-FF5E5B?logo=ko-fi&logoColor=white)](https://ko-fi.com/xronocode)

Homebrew tap for [Mark](https://github.com/xronocode/mark) — a modernized
fork of [marktext/marktext](https://github.com/marktext/marktext) tracking
[Tkaixiang/marktext](https://github.com/Tkaixiang/marktext) upstream, with
Russian localization, ad-hoc macOS signing, and a from-scratch Tauri 2
rewrite (Phase B) shipping alongside the polished Electron build (Phase A).

## Channels

This tap exposes two casks:

| cask | engine | status | who should install |
|---|---|---|---|
| `mark` | Electron 41 (Phase A) | **stable** — frozen at v1.2.3 | daily-driver users |
| `mark@alpha` | Tauri 2 (Phase B) | **preview** — Tauri rewrite in progress | maintainers + early adopters |

Phase A is the last Electron-engine release of Mark. Phase B (the Tauri
rewrite) ships in parallel as `mark@alpha` so Electron users keep an
unchanged daily-driver while the rewrite stabilizes. When Phase B v2.0
stable cuts, `mark` will roll forward to the Tauri build and the
Electron channel becomes `mark@v1` for a 12-month maintenance window
per dev-plan B3a step-4.

## Install (stable)

```sh
brew tap xronocode/mark
brew install --cask mark
```

The cask is ad-hoc signed (`codesign --sign -`), not Apple-notarized. The
postflight script clears the `com.apple.quarantine` attribute so Gatekeeper
accepts the ad-hoc signature without prompting.

## Install (alpha — Tauri preview)

⚠ **Not for daily-driver use.** The alpha boots and runs the Mark v2 boot
guards but does not yet ship the wired Vue editor shell — see the cask
caveats for what works / what doesn't.

```sh
brew tap xronocode/mark
brew install --cask mark@alpha
```

Both casks can coexist side-by-side: stable installs as `Mark.app`, alpha
installs as `Mark Alpha.app`.

## Migrate alpha → stable

When v2.0 stable ships:

```sh
brew uninstall --cask mark@alpha
brew install --cask mark         # picks up the v2.0 tag via livecheck
```

The stable v2 detects alpha installs via `mt_migration.app_version=alpha`
in `~/Library/Application Support/com.xronocode.mark/preferences.json`
and reruns missing migration sub-steps based on `mt_migration.schema_version`.

## Update (either channel)

```sh
brew upgrade --cask mark           # stable
brew upgrade --cask mark@alpha     # alpha
```

`livecheck` strategies are scoped:
- `mark` watches `v1.*` GitHub Release tags only — a `v2.*` tag does
  NOT auto-upgrade Electron users to Tauri.
- `mark@alpha` watches `v2.*-alpha.*` tags only — a `v2.0.0` stable
  release does NOT auto-upgrade alpha users; explicit migration
  command above.

## Releasing a new version (maintainer notes)

### Stable (Electron) — `mark` cask

After tagging `vX.Y.Z` on `xronocode/mark` and the GitHub Actions release
workflow publishes the DMGs:

1. Compute sha256 for both arch DMGs:
   ```sh
   curl -L -O https://github.com/xronocode/mark/releases/download/vX.Y.Z/mark-mac-arm64-X.Y.Z.dmg
   curl -L -O https://github.com/xronocode/mark/releases/download/vX.Y.Z/mark-mac-x64-X.Y.Z.dmg
   shasum -a 256 mark-mac-arm64-X.Y.Z.dmg mark-mac-x64-X.Y.Z.dmg
   ```
2. Update `Casks/mark.rb`: bump `version` and replace both `sha256` values.
3. `brew style --cask Casks/mark.rb` to lint (must pass inside a real tap
   checkout).
4. Commit and push.

### Alpha (Tauri) — `mark@alpha` cask

The Tauri build pipeline (reborn-mark) emits Mark.app + .dmg via
`tauri-action`. After tagging `v0.0.X-alpha.N` on `xronocode/mark`
(branch `tauri`):

1. Wait for the `tauri-release-dryrun` workflow to publish the alpha DMG
   to the GitHub Release.
2. Compute sha256:
   ```sh
   curl -L -O https://github.com/xronocode/mark/releases/download/v0.0.X-alpha.N/mark-mac-arm64-0.0.X-alpha.N.dmg
   shasum -a 256 mark-mac-arm64-0.0.X-alpha.N.dmg
   ```
3. Update `Casks/mark@alpha.rb`: bump `version`, replace `sha256`,
   change `:no_check` to the actual hash if the cask is on its first
   real release.
4. `brew style --cask Casks/mark@alpha.rb` to lint.
5. Commit and push.

## Support the project

Mark is built on personal time. If the tap saves you a `sudo xattr`
dance, consider buying me a coffee — it goes directly into more polish
work on both engines.

<p align="left">
  <a href="https://ko-fi.com/xronocode" target="_blank">
    <img src="https://ko-fi.com/img/githubbutton_sm.svg" alt="Buy Me a Coffee at ko-fi.com" />
  </a>
</p>
