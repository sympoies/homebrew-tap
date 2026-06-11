class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.0.16/nils-cli-v1.0.16-aarch64-apple-darwin.tar.gz"
      sha256 "e1b4bb4c50df415f2303cd4dca60da11875ca377f57255b315fe80dec8b124a4"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.0.16/nils-cli-v1.0.16-x86_64-apple-darwin.tar.gz"
      sha256 "ab72c621d207a02e7945b8102995483b74927ecdabde313c183c6abd5026c5b7"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.0.16/nils-cli-v1.0.16-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "f0007ff1366e1f8ca1d7f8723991b7f6da727681974e6fc700198a7566426920"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.0.16/nils-cli-v1.0.16-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "cc7965dff4199beba1e73bb786803ad8dba4a55034725603a62580ffe7afee0c"
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
