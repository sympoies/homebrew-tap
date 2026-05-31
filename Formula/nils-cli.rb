class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v0.31.8/nils-cli-v0.31.8-aarch64-apple-darwin.tar.gz"
      sha256 "ed181919505edfd0cf8fd37100bcc8c8c1feaacc5b22d424720e74b68f6ca3a4"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v0.31.8/nils-cli-v0.31.8-x86_64-apple-darwin.tar.gz"
      sha256 "2e42baa1ac4f99ce41566cf55579e7b00f5ee7306c26902172ed2b2b77524f13"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v0.31.8/nils-cli-v0.31.8-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "30f03b658191a7e22229b9b57c8da61744df235039aa0675ec85cc846b9b7159"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v0.31.8/nils-cli-v0.31.8-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "bafa6b37dedb5f7e358fa2fec680949f12dd931582164b9e5217ac50566d1d72"
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
