cask "mark@alpha" do
  # Historical preview channel retained for explicit legacy installs.

  version "2.0.7-alpha"
  sha256 "f47ebf3f3c98b06412da392b0406c89a36b0226eb506938ae6307aca758ba739"

  url "https://github.com/xronocode/mark/releases/download/v#{version}/Mark_#{version}_aarch64.dmg"
  name "Mark"
  desc "Mark — lightweight WYSIWYG Markdown editor (v2 Tauri alpha channel)"
  homepage "https://github.com/xronocode/mark"

  livecheck do
    skip "Historical preview channel"
  end

  auto_updates false
  depends_on arch: :arm64
  depends_on :macos

  app "Mark.app"

  # Developer ID signed + Apple notarized — no xattr needed.

  zap trash: [
    "~/Library/Application Support/com.xronocode.mark",
    "~/Library/Caches/com.xronocode.mark",
    "~/Library/Preferences/com.xronocode.mark.plist",
    "~/Library/Saved Application State/com.xronocode.mark.savedState",
  ]

  caveats <<~EOS
    Mark v#{version} is a historical preview build and no longer receives updates.

    To move to the current stable release:
      brew uninstall --cask mark@alpha
      brew install --cask mark

    Bug reports: https://github.com/xronocode/mark/issues
  EOS
end
