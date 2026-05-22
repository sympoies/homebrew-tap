class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.17.4/nils-cli-v0.17.4-aarch64-apple-darwin.tar.gz"
      sha256 "19cd86441f68b5a7a284dbda54d32f00fe15bfccc427125dccc019c169d0e0c1"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.17.4/nils-cli-v0.17.4-x86_64-apple-darwin.tar.gz"
      sha256 "a9bd6e6b792ecf29fce56138177051008038e87c0a7931e0e9f00c69e4fb6f9f"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.17.4/nils-cli-v0.17.4-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "12fcc5a1aac8d99cc34a987cd54e3e296a9e9acc3d6607c76687ec410739f0f0"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.17.4/nils-cli-v0.17.4-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "63f97b3a1c4f6fe19a56a3b0b5199e4adc8c5adc09ac3a9551d66a79b0e5e6da"
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
