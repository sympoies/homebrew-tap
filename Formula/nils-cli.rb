class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.14.0/nils-cli-v0.14.0-aarch64-apple-darwin.tar.gz"
      sha256 "dcc1e0bd47e3787459507f2771ebe79011e1f553ce57c480369dce5f6d4842ee"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.14.0/nils-cli-v0.14.0-x86_64-apple-darwin.tar.gz"
      sha256 "a00752e83739d94b6788e14c5398264aa389a824f30e755ae9682b4be8758ab8"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.14.0/nils-cli-v0.14.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "f71885222cfdd458568cc0ba7fa63a1c584d6feb2e518ea6c46c7b1978550846"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.14.0/nils-cli-v0.14.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "e9e96e17e6b4925ce7e95512327f3485f790006d2c7cb3ddd181c934d5f90cd1"
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
