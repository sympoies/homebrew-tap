class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.17.2/nils-cli-v0.17.2-aarch64-apple-darwin.tar.gz"
      sha256 "955c86a2c2e0feb2ebf26b4ac14d5d7101e3b70130db83976ecfa23e327082ca"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.17.2/nils-cli-v0.17.2-x86_64-apple-darwin.tar.gz"
      sha256 "85c8a6e816275edaa33ba4dbfd4c96462149e4ef77e53ad7f55e8811cbdc3bfb"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.17.2/nils-cli-v0.17.2-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "6161913f1ab44aef1d8b39b7e273747277b57da0c1a871a40fdeb20b2ea27df4"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.17.2/nils-cli-v0.17.2-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "79dc892c342ab5f1c82c7bd92a49d2070679cce71c6ed4a4553afda17922368b"
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
