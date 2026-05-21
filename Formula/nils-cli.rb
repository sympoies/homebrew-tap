class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.16.0/nils-cli-v0.16.0-aarch64-apple-darwin.tar.gz"
      sha256 "0ceae276a67f19cfb7f1a646f4b4155bbfdd458f7dd6576f3b0db9b5410cf8b6"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.16.0/nils-cli-v0.16.0-x86_64-apple-darwin.tar.gz"
      sha256 "4dac37d8ff5c238e3a67b01a9dca39c5f50315e070f10b4158a069887306e9f3"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.16.0/nils-cli-v0.16.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "eb96fd1be6d710a96edf2b691b4dd293c8f38f0860fdfb1d6800ec87f009af0e"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.16.0/nils-cli-v0.16.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "853af8d49ae2383a8f849d1f3dd556e26db4ab016d61e35774ca4f38866fb4cf"
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
