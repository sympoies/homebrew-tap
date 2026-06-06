class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.0.11/nils-cli-v1.0.11-aarch64-apple-darwin.tar.gz"
      sha256 "498256ab89512f6a3e2905f2d6a669cb21c59294e92e3dc4fca904f22234c1a1"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.0.11/nils-cli-v1.0.11-x86_64-apple-darwin.tar.gz"
      sha256 "c7ffd5f8b86845e09cea3f497ba53a68b909c9ed64ceb21a81d93d801acb82bb"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.0.11/nils-cli-v1.0.11-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "26e5fb5f2ba0adbcd202bd69e41a0ac1f6d9c59af8d7d8056ed654ec1791b6c8"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.0.11/nils-cli-v1.0.11-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "ac5aa41d026a1034aa9731c43bf130d88f0d9ca28648d6962d33900c38d4880d"
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
