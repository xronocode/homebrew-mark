cask "mark@alpha" do
  # Phase-B Tauri rewrite — alpha channel.
  #
  # ⚠ ALPHA: this build does NOT yet ship a fully wired Vue editor shell.
  # The bundled binary boots, runs the M-001 boot guards (panic hook,
  # security audit, fixture validation), and opens a window with the
  # muya bench harness. Real editor functionality (sidebar, tabs,
  # source-code mode) lands when F-MAIN-ENTRY-DISABLED is closed in
  # a Phase-B3a follow-up.
  #
  # WHO SHOULD INSTALL: maintainers + early adopters who want to track
  # the Tauri rewrite progress. Not for daily-driver use.
  # WHO SHOULD NOT: anyone whose Mark workflow depends on actually
  # opening + saving Markdown files. Stay on `mark` (v1.2.x Electron)
  # until v2.0 stable.
  #
  # Pinned to a draft version — when the alpha actually publishes a
  # tag, the version string + sha256 update here. Until then the cask
  # is a skeleton; `brew install --cask mark@alpha` will fail with a
  # helpful odie until the first alpha release lands.

  version "0.0.1-alpha.1"

  on_arm do
    sha256 :no_check
    url "https://github.com/xronocode/mark/releases/download/v#{version}/mark-mac-arm64-#{version}.dmg",
        verified: "github.com/xronocode/mark/"
  end

  on_intel do
    odie "Mark Tauri alpha ships Apple Silicon only. Intel users stay on `mark` (v1.2.x Electron) — universal binary is a v2.1+ goal per dev-plan B3a step-10."
  end

  name "Mark (Tauri alpha)"
  desc "Mark v2 Tauri-engine alpha — preview the rewrite; not for daily use"
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

  app "Mark.app", target: "Mark Alpha.app"

  # Phase-B3a step-6: alpha cask postinstall message.
  caveats <<~EOS
    ⚠ ALPHA channel — preview build of the Mark Tauri rewrite.

    What works:
      - App boots; M-001 boot guards (panic hook, security audit,
        IPC contract validation) run cleanly.
      - Bench harness window renders muya markdown.

    What doesn't work yet:
      - Editor sidebar, tabs, source-code mode — wired in B3a follow-up
        (F-MAIN-ENTRY-DISABLED resolves this).
      - File open / save end-to-end — backend modules ready
        (M-002/003/004); renderer wiring pending.
      - Auto-updates — feed not configured; `Check for Updates` is a
        stub until B4 ships dual-pubkey signing infra.

    Preferences:
      - Stored at ~/Library/Application Support/com.xronocode.mark/
        preferences.json with mt_migration.app_version="alpha".
      - Treated as READ-ONLY for legacy v1.2.x prefs; alpha does NOT
        currently migrate v1's preferences.json / dataCenter.json /
        keybindings.json / recently-used-documents.json
        (F-PREFS-MIGRATE-V1 tracks the full migration).

    To migrate to stable v2 when it ships:
      brew uninstall --cask mark@alpha
      brew install --cask mark   # rolls forward via livecheck

    Bug reports: https://github.com/xronocode/mark/issues
    Tag with `alpha` label.
  EOS

  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-cr", "#{appdir}/Mark Alpha.app"],
                   sudo: false
  end

  zap trash: [
    "~/Library/Application Support/com.xronocode.mark",
    "~/Library/Caches/com.xronocode.mark",
    "~/Library/Preferences/com.xronocode.mark.plist",
    "~/Library/Saved Application State/com.xronocode.mark.savedState",
  ]
end
