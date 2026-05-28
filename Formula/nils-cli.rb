class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.25.7/nils-cli-v0.25.7-aarch64-apple-darwin.tar.gz"
      sha256 "d9c974ec104e7a6d0787e90081f4789cf15694504265c4cea3ad908d53a6710a"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.25.7/nils-cli-v0.25.7-x86_64-apple-darwin.tar.gz"
      sha256 "1dc207ac2968fb478a10097080ea8adac2e89d2e0a0b02f8d85ca0c4c4efa3df"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.25.7/nils-cli-v0.25.7-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "09d02793b42c21b1cfa6abb0acd55d9c87f9b07361f3ddbeac43e9fec1f2607e"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.25.7/nils-cli-v0.25.7-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "dfa3120d19d4c837b2b25f38cab847c3bc2a82bd7919fd177b41b857e9506dac"
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
