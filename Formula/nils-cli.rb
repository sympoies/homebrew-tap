class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.31.10/nils-cli-v1.31.10-aarch64-apple-darwin.tar.gz"
      sha256 "8c39317de92ca5a12b372b593837fc7da1fe34298e0034d972df1f3275193f9b"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.31.10/nils-cli-v1.31.10-x86_64-apple-darwin.tar.gz"
      sha256 "9f6c44e2460c8dcc736a273d60f54db6f319a3afb7fdf433d1f1d6cf3872bb76"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.31.10/nils-cli-v1.31.10-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "98db489699f42a30057c16d151325f274f829a3da547b06bb50cae78f7f21d44"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.31.10/nils-cli-v1.31.10-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "440c6a7aec1f74a32ccd6e7b45a5af583d99d5ecd62b5dab4daa5b8fd1c86908"
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
