class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.29.1/nils-cli-v1.29.1-aarch64-apple-darwin.tar.gz"
      sha256 "36ce25408eebc910c0b3037d482484287c07ed7cc56bea6809bd8b630d5373e3"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.29.1/nils-cli-v1.29.1-x86_64-apple-darwin.tar.gz"
      sha256 "626ab1be2fc5857bdb4b9cc4972abcb48843e93472a5d0e6a4ac911baa0537c4"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.29.1/nils-cli-v1.29.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "179eabc0be4109a58591b64ad150ad78b0e953e29d4a980f3b3ea1ba5780f64f"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.29.1/nils-cli-v1.29.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "333c0a384017b4c801d7a05047b67e1a2fa6ce222298114206cd4fedce7f2180"
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
