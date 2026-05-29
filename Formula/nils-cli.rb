class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v0.28.3/nils-cli-v0.28.3-aarch64-apple-darwin.tar.gz"
      sha256 "014e84bd73b19d2ec1ca34e3a58726c3bbdb9a29e44edd17b1bfbf9b2babe745"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v0.28.3/nils-cli-v0.28.3-x86_64-apple-darwin.tar.gz"
      sha256 "9ed0114341f17accad1e7c3fd651cf345b1965d4045044ace903d4bed8794c36"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v0.28.3/nils-cli-v0.28.3-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "9475c24a7f6ddc68f92dbf782fbf1a2fe135c5b43af9d6f4f93d43d68f3ea58a"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v0.28.3/nils-cli-v0.28.3-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "e3eaf2c8f6117c8375b51cb7a019da837eb2e9566e76fe3009b259f0c1783895"
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
