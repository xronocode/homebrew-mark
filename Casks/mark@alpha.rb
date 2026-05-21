cask "mark@alpha" do
  # Phase-B Tauri rewrite — alpha channel.
  #
  # ALPHA: usable for routine writing on macOS Apple Silicon — that's how
  # it's developed. Known gaps tracked in docs/development-plan.xml
  # followup index. For a frozen Electron-engine alternative, install
  # `mark` (Phase A v1.2.x) instead.
  #
  # WHO SHOULD INSTALL: Apple Silicon users wanting the lightweight
  # Tauri rewrite (~25 MB binary, sub-second cold start). Cross-window
  # prefs broadcast, file watcher, dirty-tab close prompt, native menu,
  # global shortcut, Mermaid v11 / KaTeX / Vega diagrams all work.
  # WHO SHOULD NOT: anyone who needs Cmd+F in-file find, in-folder
  # ripgrep search, or Linux/Windows builds — those are deferred to
  # beta. Stay on `mark` (v1.2.x) for those.

  version "2.0.0-alpha.7"
  sha256 "3dbca2c41e88d75f08398470a07c8acffc9f215c7ffb3779973eedfdcc377da9"

  on_arm do
    url "https://github.com/xronocode/mark/releases/download/v#{version}/Mark_#{version}_aarch64.dmg",
        verified: "github.com/xronocode/mark/"
  end

  on_intel do
    odie "Mark Tauri alpha ships Apple Silicon only. Intel users stay on `mark` (v1.2.x Electron) — universal binary is a v2.1+ goal per dev-plan B3a step-10."
  end

  name "Mark"
  desc "Mark — lightweight WYSIWYG Markdown editor (v2 Tauri alpha channel)"
  homepage "https://github.com/xronocode/mark"

  # livecheck restricted to v2.*-alpha.* tags so a v2.0 stable doesn't
  # auto-upgrade alpha users — they should explicitly migrate via:
  #   brew uninstall --cask mark@alpha
  #   brew install --cask mark
  # (per dev-plan B3a step-8 documented migration command).
  livecheck do
    url :url
    strategy :github_latest do |json|
      tag = json["tag_name"]
      tag.start_with?("v2.") && tag.include?("alpha") ? tag.delete_prefix("v") : nil
    end
  end

  auto_updates false
  depends_on macos: ">= :big_sur"

  app "Mark.app"

  caveats <<~EOS
    Mark v#{version} — Tauri rewrite preview build.

    What works (alpha):
      - WYSIWYG markdown editing (muya engine), multi-tab, save/save-as
      - Open Folder + sidebar tree, external-edit live reload
      - Cross-window preference broadcast (Settings <-> Editor)
      - Theme switching (light/dark/sepia + 15 named palettes)
      - Native macOS menu, global shortcut Cmd+Shift+M
      - Dirty-tab close prompt (Cmd+W on unsaved file)
      - Mermaid v11 / KaTeX / Vega diagrams, table editor
      - Spell-check via NSSpellChecker
      - Auto-import of preferences from Mark Text v1.2.x (silent on
        first launch — no dialog)
      - Auto-update via Homebrew: `brew upgrade --cask mark@alpha`

    Deferred to beta:
      - Cmd+F in-file find, in-folder ripgrep search
      - Print to PDF (works only if Pandoc on PATH)
      - Linux / Windows builds

    Out of scope: plugin marketplace.

    Preferences storage:
      ~/Library/Application Support/com.xronocode.mark/preferences.json
    Original Mark Text v1.x data at
      ~/Library/Application Support/marktext
    is read-only for the migrator and stays untouched.

    To roll forward when v2.0 stable ships:
      brew uninstall --cask mark@alpha
      brew install --cask mark   # picks up the v2.0 tag via livecheck

    Bug reports: https://github.com/xronocode/mark/issues
    Sponsor:     https://ko-fi.com/xronocode
  EOS

  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-cr", "#{appdir}/Mark.app"],
                   sudo: false
  end

  zap trash: [
    "~/Library/Application Support/com.xronocode.mark",
    "~/Library/Caches/com.xronocode.mark",
    "~/Library/Preferences/com.xronocode.mark.plist",
    "~/Library/Saved Application State/com.xronocode.mark.savedState",
  ]
end
