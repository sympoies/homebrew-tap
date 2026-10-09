class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.32.5/nils-cli-v1.32.5-aarch64-apple-darwin.tar.gz"
      sha256 "bf86d749a55efa4a0d3b3723870ab8cc0bf66aae551685c651dd53f5f0deaaef"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.32.5/nils-cli-v1.32.5-x86_64-apple-darwin.tar.gz"
      sha256 "5a9b85f6f057a29c56f0e6ca8da24eac5c1a44412362ac3fee319f2bf202801e"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.32.5/nils-cli-v1.32.5-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "f746cef0d582c19ae9f3f23501a16ce577630b99a46cbad49635b925f7b8481b"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.32.5/nils-cli-v1.32.5-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "283b43a06a4b20c3ac305439fd9c59cfdc97de58a66ff51e7ff7c89978e1d597"
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
      ENV["AGENT_RUN_FORMULA_TEST"] = nil
      (testpath/".env").write("AGENT_RUN_FORMULA_TEST=ok\n")
      system "#{bin}/agent-run", "exec", "--cwd", testpath, "--", "sh", "-c",
             "test \"$AGENT_RUN_FORMULA_TEST\" = ok"
    end
  end
end
