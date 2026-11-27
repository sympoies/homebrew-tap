class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.45.0/nils-cli-v1.45.0-aarch64-apple-darwin.tar.gz"
      sha256 "e90c7d92f0ea00c416ed5fb2cd0adf393d6ebb27a0c18c85678d3467acc96954"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.45.0/nils-cli-v1.45.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "b1ef82e419f03ad165aed5dffad1f059a53b449e289384b2968287663e90b629"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.45.0/nils-cli-v1.45.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "2c259d94242bfb52e4963c22c05e10e653c6ca7a694e524594a58e35970067bf"
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
