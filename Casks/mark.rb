cask "mark" do
  version "2.7.0"
  sha256 "0b0c44ed8595bb5a73a8a70fc46f93a9a4ecbaf4f32fa3db46429c25d1aea8d2"

  url "https://github.com/xronocode/mark/releases/download/v#{version}/Mark_#{version}_aarch64.dmg"
  name "Mark"
  desc "Lightweight WYSIWYG Markdown editor powered by Tauri"
  homepage "https://github.com/xronocode/mark"

  # Version and checksum updates are opened by Mark's protected release
  # workflow. GitHub's latest endpoint intentionally omits beta prereleases.

  auto_updates false
  depends_on arch: :arm64
  depends_on :macos

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
