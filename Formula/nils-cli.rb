class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.21.0/nils-cli-v0.21.0-aarch64-apple-darwin.tar.gz"
      sha256 "b55e747e17d9b4eea8fb15f6e743da760dcd64ceb70e68a1fc66c7eedc8649fe"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.21.0/nils-cli-v0.21.0-x86_64-apple-darwin.tar.gz"
      sha256 "51f669ea7548ca3199f030aa9c5558bb407ac6be910b899442be61a15ab6b113"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.21.0/nils-cli-v0.21.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "9cea6529637fb4667c781225869b7bcc841295639459ff47372e01ee15e38a37"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.21.0/nils-cli-v0.21.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "181204be2648c4b8645464162a49b61ebf2a60d3ee0b1c67deb743246cd16d18"
    end
  end

  def install
    bin.install Dir["bin/*"]
    zsh_completion.install Dir["completions/zsh/*"]

    bash_files = Dir["completions/bash/*"]
    bash_completion_files = bash_files.reject { |f| File.basename(f) == "aliases.bash" }
    bash_completion.install bash_completion_files if bash_completion_files.any?

    bash_aliases = bash_files.find { |f| File.basename(f) == "aliases.bash" }
    pkgshare.install bash_aliases => "aliases.bash" if bash_aliases
  end

  test do
    system "git", "init", testpath
    cd testpath do
      system "#{bin}/git-scope", "--help"
    end
  end
end
