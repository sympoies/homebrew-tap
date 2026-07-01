# frozen_string_literal: true

cask "symphony-board" do
  version "1.12.7"
  sha256 "6cee0704f49779ec7d1af944cd59b44ea8678d3e4b93fb364c6a0c0456bb0963"

  url "https://github.com/sympoies/symphony-board/releases/download/v#{version}/Symphony-Board-v#{version}-macos-arm64-unsigned.zip"
  name "Symphony Board"
  desc "Read-only desktop client for Symphony Board"
  homepage "https://github.com/sympoies/symphony-board"

  depends_on arch: :arm64
  depends_on macos: :big_sur

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
