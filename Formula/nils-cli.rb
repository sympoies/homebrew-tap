class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.7.4/nils-cli-v0.7.4-aarch64-apple-darwin.tar.gz"
      sha256 "1652f137ce851d99b7e0ab2058ed1d60d63314beddfccb643cdbb25179c550b1"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.7.4/nils-cli-v0.7.4-x86_64-apple-darwin.tar.gz"
      sha256 "bb5f1f414b683c9792fb082093b08f6374f7c5330a3dfc2e5b848cddfdd493d2"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.7.4/nils-cli-v0.7.4-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "eaf9ba07226fcc39619996e822fd2604c242482014ebcbade5fb67a4f017fb85"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.7.4/nils-cli-v0.7.4-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "64f6078926fead36979e18f096b5ad6e3caf01d91d6eb31691332313589dfd8e"
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
