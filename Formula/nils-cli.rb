class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.9.2/nils-cli-v1.9.2-aarch64-apple-darwin.tar.gz"
      sha256 "0b50603e2952233e4d95e7c5aa90a47d5314f63c9b47a8a47c0fdfb2b4e63c0e"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.9.2/nils-cli-v1.9.2-x86_64-apple-darwin.tar.gz"
      sha256 "f4061b2f605d1d6031674a7ebcc889e56fe58e7218dde2262831dbcb83055abf"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.9.2/nils-cli-v1.9.2-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "2d5f680176b29cd0c8ff3771643ac9ad52c2a07a76c97d08dc2ad2caf445614f"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.9.2/nils-cli-v1.9.2-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "b65d79e5fcfae4ec4cc1bee2775909e87c17f4a3855fe546bd3f891d1fd5cfc7"
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
