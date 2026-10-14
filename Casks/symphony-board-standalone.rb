# frozen_string_literal: true

cask "symphony-board-standalone" do
  version "1.27.5"
  sha256 "bc5c51b572116e06f0e5cd703f3378a0e87a67f2813798016df44e5b52b57d1c"

  url "https://github.com/sympoies/symphony-board/releases/download/v#{version}/Symphony-Board-Standalone-v#{version}-macos-arm64-unsigned.zip"
  name "Symphony Board Standalone"
  desc "Self-contained desktop app for Symphony Board"
  homepage "https://github.com/sympoies/symphony-board"

  depends_on arch: :arm64
  depends_on :macos

  app "Symphony Board Standalone.app"

  zap trash: [
    "~/Library/Application Support/com.sympoies.symphony-board.standalone",
    "~/Library/Preferences/com.sympoies.symphony-board.standalone.plist",
    "~/Library/Saved Application State/com.sympoies.symphony-board.standalone.savedState",
  ]

  caveats <<~EOS
    This app is unsigned and not notarized. If macOS blocks launch after install, remove quarantine manually:

      xattr -dr com.apple.quarantine "/Applications/Symphony Board Standalone.app"
      open "/Applications/Symphony Board Standalone.app"
  EOS
end
