cask "mark" do
  version "2.8.2"
  sha256 "b8cd40863b2a0c421afec03a6c474b1987469f48597f8c40ce6d0a8634df1f5e"

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
