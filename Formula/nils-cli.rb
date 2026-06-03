class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.0.6/nils-cli-v1.0.6-aarch64-apple-darwin.tar.gz"
      sha256 "459dc968b73cf83245e109b35d8e640b999eb9a2158431fc2ebcdcc611de259a"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.0.6/nils-cli-v1.0.6-x86_64-apple-darwin.tar.gz"
      sha256 "316a20702bd0cd0149ea22f3bf00203e2e002919909ae3798ecfb62828ca85f8"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.0.6/nils-cli-v1.0.6-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "245845518bf2b8a3cd292768db2f6b2fd30d0a78ab2ff19c3b65e965e42adff4"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.0.6/nils-cli-v1.0.6-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "5c98a7acac49ddeab2cf0c17be8ddc7465b364737d9215368b930af8d60359fa"
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
