class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.17.7/nils-cli-v0.17.7-aarch64-apple-darwin.tar.gz"
      sha256 "71a2a91bb87099e92d6c1f629c099fd0c6cb80e535cb9ca0f50b0e479b8175c6"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.17.7/nils-cli-v0.17.7-x86_64-apple-darwin.tar.gz"
      sha256 "b9db48d01d8417ee3221d6b0cacbc3f9b5f22699d2796fc42b2c84addefacb4b"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/graysurf/nils-cli/releases/download/v0.17.7/nils-cli-v0.17.7-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "4445b4b86cd0ca2fcadc0ad77c714316c7b037f3664603874a4ea25990b83200"
    else
      url "https://github.com/graysurf/nils-cli/releases/download/v0.17.7/nils-cli-v0.17.7-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "963861794457312058ea272c2ea2594db3866b02780cdc74bacb1f7d20b9ed0a"
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
