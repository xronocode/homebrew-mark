cask "mark" do
  version "1.0.2"

  on_arm do
    sha256 "a585b5167bbe3d248f5cdb2f545ce58e95b485baf7dae29ce1cf04a8a978597a"

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

  livecheck do
    url :url
    strategy :github_latest
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
