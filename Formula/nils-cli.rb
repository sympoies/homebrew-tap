class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v0.26.1/nils-cli-v0.26.1-aarch64-apple-darwin.tar.gz"
      sha256 "cd3d54a7baa28d3f8ef42f522480e52227b21af7e50356d0dcc1a91b6efe44c1"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v0.26.1/nils-cli-v0.26.1-x86_64-apple-darwin.tar.gz"
      sha256 "957a8600abbaf4bd28ecc0adb5c31bc30bacab4f6f8e0752e0019b0a128aad0d"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v0.26.1/nils-cli-v0.26.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "6f81551a4c4ffbdf3953ffba7c8a51ad6983ba5145afdc8bfb9cb2e71c466c12"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v0.26.1/nils-cli-v0.26.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "398edb28e664931b6762119b7a6f38f8ce675e03637cc3369d206cbeb414e6c0"
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
