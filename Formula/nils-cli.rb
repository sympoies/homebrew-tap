class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.12.0/nils-cli-v0.12.0-aarch64-apple-darwin.tar.gz"
      sha256 "97e14656d07b0d5833ff8e1e1f17e8df6191f2b8636a5e84f2a1de65462b819f"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.12.0/nils-cli-v0.12.0-x86_64-apple-darwin.tar.gz"
      sha256 "db32894869be42bdf732122e51a15aaf5f2c2f7b491b158ab95114a553162a3a"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.12.0/nils-cli-v0.12.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "8ce4861d3e88af14bfac5f37841ca3711e0ce390762aac06d5f5fbacd535d45f"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.12.0/nils-cli-v0.12.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "0b614071db4ffbc3e21afa8aad9f7899ba17a8250e01302b3d8ac0eb6b13455c"
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
