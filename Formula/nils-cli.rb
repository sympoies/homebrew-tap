class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v0.31.1/nils-cli-v0.31.1-aarch64-apple-darwin.tar.gz"
      sha256 "120adc78cf156367dee4de8f9180d1caf1b4f7a27156b92563fbe21fe87f6478"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v0.31.1/nils-cli-v0.31.1-x86_64-apple-darwin.tar.gz"
      sha256 "ac0cd5d68bdc8ed03993b21949342100c682e8aef7231e76c54e380f314addf7"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v0.31.1/nils-cli-v0.31.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "8c8f6511b1a6bf07ab85d68ab9e9b669c900ac0c2b898bbb7da21301e16ee92f"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v0.31.1/nils-cli-v0.31.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "c88ff9ef10c97c8a22c1ed6948a833c4110f4a3f070b19fd806637e340ddc3a0"
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
