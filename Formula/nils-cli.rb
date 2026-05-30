class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v0.28.6/nils-cli-v0.28.6-aarch64-apple-darwin.tar.gz"
      sha256 "ee3c08cf53a5c43be220df3d27e3c175400636f4098dca3a54c59f090e4eabcf"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v0.28.6/nils-cli-v0.28.6-x86_64-apple-darwin.tar.gz"
      sha256 "4e6d21103d23c988b3fa2f5c5dd8b4c6e1ec75f1a736083d49ee97b643ffe67a"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v0.28.6/nils-cli-v0.28.6-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "4c14cd78d2f4d35a3056b5bf2091afeb00b188c9df4bf4a8266c9b3023e0fca4"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v0.28.6/nils-cli-v0.28.6-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "b5b6f45ba74a1fcb45ffd85a9a4588bb81b86e91c3d93f54ec3c1a14f8fd5c56"
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
