class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.17.1/nils-cli-v0.17.1-aarch64-apple-darwin.tar.gz"
      sha256 "2447b1710702931e93ca1e820763ceb2d1a57c94b6e0395737a4e53144c11b6c"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.17.1/nils-cli-v0.17.1-x86_64-apple-darwin.tar.gz"
      sha256 "499e1e3f527ba7587f9c13acd4c81326fa97e0073cd387f75ad903ceb130811a"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.17.1/nils-cli-v0.17.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "a7734a4a7ef5fe7cc0e8a76851aa1dc24db0530ed3bf9e9e26494fe9598fb649"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.17.1/nils-cli-v0.17.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "35b1b50afd39d8274afe9ab213aab57ae8d5c0d9017e6059b73c218b65cccc3c"
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
