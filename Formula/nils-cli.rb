class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.7.1/nils-cli-v1.7.1-aarch64-apple-darwin.tar.gz"
      sha256 "3a9cefc15b87a2e3fe6da6cac9b7e0d9f0b51f312c83e10a8bae521ce605a52b"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.7.1/nils-cli-v1.7.1-x86_64-apple-darwin.tar.gz"
      sha256 "3312610b3710f70d3139b06f871cd83d9ae686ea591a1e4e48b0bc04082482de"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.7.1/nils-cli-v1.7.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "80d1d7d579244bf86460319d8302c41b8988291a978aba781b0e972770f119c9"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.7.1/nils-cli-v1.7.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "41f80b0056712e6cdaa819ee732e9b29e69bb976a6867db02340ceb5d90d8bb9"
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
