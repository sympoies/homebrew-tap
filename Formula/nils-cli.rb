class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.25.1/nils-cli-v0.25.1-aarch64-apple-darwin.tar.gz"
      sha256 "da2bb2ebc3be399ca5d6f039025827ecb5888fb2b28510cf9c158b540b5db7e4"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.25.1/nils-cli-v0.25.1-x86_64-apple-darwin.tar.gz"
      sha256 "ee0cefa27ecf9fc3d97110810061555d87ddc5728b45f8ea1ab57a47b6fd3e6a"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.25.1/nils-cli-v0.25.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "e4bd255d53be9924c2aef7cb088dc9ac196bcb7375715de8912cc15539c28c82"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.25.1/nils-cli-v0.25.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "f77c04b314d7d708ee289e42a96f82d379d6d080117f46884cd9c624ca8a6d66"
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
