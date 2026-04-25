class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.7.2/nils-cli-v0.7.2-aarch64-apple-darwin.tar.gz"
      sha256 "635a16309df4653aea1f5131273a1f90edf21727daa8114395ff2c90c05212c4"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.7.2/nils-cli-v0.7.2-x86_64-apple-darwin.tar.gz"
      sha256 "d864324cc1aad801aa0a30799624c073dca1421e3accd91da2e817eb429f1d31"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.7.2/nils-cli-v0.7.2-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "66c5facfc5c5ed9b7f865011a1bccb32459f8c363b99c01dfaf1ebc513035417"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.7.2/nils-cli-v0.7.2-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "f9411d9578803705bc234a53989a6687cfe8d6f747a5e14f8fa7bd7898420b74"
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
