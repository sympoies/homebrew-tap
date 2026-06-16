class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.9.1/nils-cli-v1.9.1-aarch64-apple-darwin.tar.gz"
      sha256 "745aa777551972cdcc11bd7bca845a50e078013b2a957e04b9794529243e551a"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.9.1/nils-cli-v1.9.1-x86_64-apple-darwin.tar.gz"
      sha256 "cd63edf3629cd942e525b22f0700faaa4f00e81d9a546e0488d7ca4606b9ee62"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.9.1/nils-cli-v1.9.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "865fe32bdbb106f3f09aa8f42907083d0c6e375f5662f7f4572b6cf57b77f458"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.9.1/nils-cli-v1.9.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "400b3b231f92d728543f85127cd7892c901994b6a2b3d5c902548f7e353c14bc"
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
