class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.0.13/nils-cli-v1.0.13-aarch64-apple-darwin.tar.gz"
      sha256 "b4778e825ecf2dbbe1a8129d0a0a3e9f2b896479e442c09512191dce27d26878"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.0.13/nils-cli-v1.0.13-x86_64-apple-darwin.tar.gz"
      sha256 "944f94e96e65ced48ea96517f8d716ff503bb033d799cae173636824c5abaf81"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.0.13/nils-cli-v1.0.13-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "889615549ed458d5a13870d7407f36930372cd50f1aff5b047c89a4d3e65dff8"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.0.13/nils-cli-v1.0.13-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "99c09a42801574d4a741a6d4a3d7262cf0a74064b6928e330d1eff341f356850"
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
