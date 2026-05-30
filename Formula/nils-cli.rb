class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v0.30.1/nils-cli-v0.30.1-aarch64-apple-darwin.tar.gz"
      sha256 "3bf85cdba909ef5492974db8960ad017843aa43d449df1b917e6d690950c0dad"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v0.30.1/nils-cli-v0.30.1-x86_64-apple-darwin.tar.gz"
      sha256 "553e5ba1299f024df98089a9a750e221e92b8559e59b381f8b3026e5e2c783b5"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v0.30.1/nils-cli-v0.30.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "604676b62f6db84f0b76a655238fd09a086ece5ee6fc203e4d8c2b1e52860347"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v0.30.1/nils-cli-v0.30.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "1534ca272652058c8bc3046ccba44a8422a8bacd95a8e8b9c5b8c3c9f86a1cef"
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
