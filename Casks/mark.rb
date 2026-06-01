cask "mark" do
  version "2.0.2-alpha"

  on_arm do
    sha256 "ac4257c21f7e3d1e6fa2eb38dae65a6e2895ca8057fc3b7f9b2d068b8486141e"

    url "https://github.com/xronocode/mark/releases/download/v#{version}/mark-mac-arm64-#{version}.dmg",
        verified: "github.com/xronocode/mark/"
  end

  on_intel do
    # Intel macOS still pending — the macos-13 GitHub Actions runner remains
    # queue-bound during release windows, and the macos-14 cross-build
    # produces an x64 DMG with arm64 native modules (broken on Intel).
    # Tracking in https://github.com/xronocode/mark/issues.
    odie "Mark v#{version} ships Apple Silicon only. Intel builds coming in a follow-up release."
  end

  name "Mark"
  desc "Lightweight Markdown editor — modernized fork of MarkText with Russian support"
  homepage "https://github.com/xronocode/mark"

  # Phase A frozen at v1.2.3. This is the LAST Electron-engine release of
  # Mark — Phase B ships as a separate Tauri-engine binary on the
  # `mark@alpha` cask (read-only legacy preferences; no auto-update).
  # When Phase B v2.0 stable cuts, this cask gets a `mark@v1` rename
  # for the 12-month maintenance window per dev-plan B3a step-4.
  #
  # livecheck stays bounded by `v1.*` tag prefix so a v2.* GitHub
  # Release doesn't accidentally upgrade Electron users to Tauri.
  livecheck do
    url :url
    strategy :github_latest do |json|
      tag = json["tag_name"]
      tag.start_with?("v1.") ? tag.delete_prefix("v") : nil
    end
  end

  auto_updates false
  depends_on macos: ">= :big_sur"

  app "Mark.app"

  # Mark releases are ad-hoc signed (codesign --sign -) but not Apple-notarized.
  # Strip the quarantine attribute on first install so Gatekeeper accepts the
  # ad-hoc signature without prompting.
  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-cr", "#{appdir}/Mark.app"],
                   sudo: false
  end

  zap trash: [
    "~/Library/Application Support/mark",
    "~/Library/Preferences/com.xronocode.mark.plist",
    "~/Library/Saved Application State/com.xronocode.mark.savedState",
    "~/Library/Logs/Mark",
  ]
end
