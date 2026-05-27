class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.25.4/nils-cli-v0.25.4-aarch64-apple-darwin.tar.gz"
      sha256 "a7a6da4001686c2710b32e122e06f567d68c86821eb0a4022caa9211b725d6ca"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.25.4/nils-cli-v0.25.4-x86_64-apple-darwin.tar.gz"
      sha256 "a4ce316e1e52948a9e7ddee6bc9d327ccf216e81cbbbe26a5f4b4966f374fa64"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.25.4/nils-cli-v0.25.4-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "09240cb46911d7b8762073579d90dc2fcf1b1c955e1c299581d0bece09615b2f"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.25.4/nils-cli-v0.25.4-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "f171e7aaefc27e35c13bd8b2c9f0ec75a635f2b1580e027109eebb3d13b8a6fb"
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
