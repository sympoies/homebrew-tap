class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.31.9/nils-cli-v1.31.9-aarch64-apple-darwin.tar.gz"
      sha256 "7ecc7e1deabd1c0a26a5d5c344f9935f4c1fa24be716e267d3573f9a1ad0c983"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.31.9/nils-cli-v1.31.9-x86_64-apple-darwin.tar.gz"
      sha256 "b3e471d5d9de4785b95e338c6ca0a0d8a4f15c0dbc41db52a7d2421c883537f6"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.31.9/nils-cli-v1.31.9-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "c1b104d45cb86fbe29ba91163668bad6a8eab055d3dc86ce4245862221675348"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.31.9/nils-cli-v1.31.9-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "3e09b5c5eb2398645a50825a543cce13c8e1fb4d67ed5ffbb811a63b12ece6bb"
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
