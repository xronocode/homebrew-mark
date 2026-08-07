cask "mark" do
  version "2.1.3-beta"

  on_arm do
    sha256 "34f32d6ab20d8ed5c543e3a03d8a01f13cb008ef8a9162efd0a9b053b974a821"

    url "https://github.com/xronocode/mark/releases/download/v#{version}/Mark_#{version}_aarch64.dmg",
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
  desc "Lightweight WYSIWYG Markdown editor powered by Tauri"
  homepage "https://github.com/xronocode/mark"

  # Version and checksum updates are opened by Mark's protected release
  # workflow. GitHub's latest endpoint intentionally omits beta prereleases.

  auto_updates false
  depends_on macos: :big_sur

  app "Mark.app"

  # Developer ID signed and Apple notarized; no quarantine workaround needed.

  zap trash: [
    "~/Library/Application Support/com.xronocode.mark",
    "~/Library/Caches/com.xronocode.mark",
    "~/Library/Logs/Mark",
    "~/Library/Preferences/com.xronocode.mark.plist",
    "~/Library/Saved Application State/com.xronocode.mark.savedState",
  ]
end
