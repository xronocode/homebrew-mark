# homebrew-mark

Homebrew tap for [Mark](https://github.com/xronocode/mark), a lightweight
WYSIWYG Markdown editor powered by Tauri.

## Install

Mark currently ships a signed and notarized Apple Silicon build:

```sh
brew tap xronocode/mark
brew install --cask mark
```

Upgrade with:

```sh
brew upgrade --cask mark
```

Intel macOS is not supported by the current cask. Windows installers are
published directly on the Mark GitHub releases page.

## Release automation

The protected Mark release workflow opens an exact cask bump pull request
using the release GitHub App. This tap runs the required `cask/validate`
check over the cask, including Homebrew style, strict online audit, artifact
download, and checksum verification. The bot-generated pull request is
eligible for squash auto-merge only after that required check succeeds.

The audit has one explicit exception: `token_conflicts`, because Homebrew Core
contains an unrelated formula also named `mark`. No URL, checksum, signing,
style, or artifact-download audit is waived.

Version and checksum values come from the published release and its committed
`.sha256` sidecar. They are never recomputed from a different artifact.

## Support

Bug reports belong in the [Mark issue tracker](https://github.com/xronocode/mark/issues).
If the project is useful, you can [support its development](https://ko-fi.com/xronocode).
