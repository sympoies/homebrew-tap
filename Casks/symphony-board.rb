# frozen_string_literal: true

cask "symphony-board" do
  version "1.27.19"
  sha256 "9f38811eb5fa240bd058dd1b5923482a133f52e2b32eb861efbae2bba7d9210b"

  url "https://github.com/sympoies/symphony-board/releases/download/v#{version}/Symphony-Board-v#{version}-macos-arm64-unsigned.zip"
  name "Symphony Board"
  desc "Read-only desktop client for Symphony Board"
  homepage "https://github.com/sympoies/symphony-board"

  depends_on arch: :arm64
  depends_on :macos

  app "Symphony Board.app"

  zap trash: [
    "~/Library/Application Support/com.sympoies.symphony-board",
    "~/Library/Preferences/com.sympoies.symphony-board.plist",
    "~/Library/Saved Application State/com.sympoies.symphony-board.savedState",
  ]

  caveats <<~EOS
    This app is unsigned and not notarized. If macOS blocks launch after install, remove quarantine manually:

      xattr -dr com.apple.quarantine "/Applications/Symphony Board.app"
      open "/Applications/Symphony Board.app"

    The thin client requires a running Symphony Board server. Configure the server URL in Settings.
  EOS
end
