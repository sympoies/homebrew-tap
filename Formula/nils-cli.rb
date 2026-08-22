class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.3/nils-cli-v1.27.3-aarch64-apple-darwin.tar.gz"
      sha256 "95d9417d442e6f8ea020e6555551dd4476478b0d1d635c6f63966647f57bcefd"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.3/nils-cli-v1.27.3-x86_64-apple-darwin.tar.gz"
      sha256 "35ac32477ee51205c778ed95efdd41dceeaac678d141ca7440f86e0b789fb1c4"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.3/nils-cli-v1.27.3-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "f78a90ccec34b58f1dcba0e36050c9297cff6f93b3fecadde6af66cbab65d514"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.3/nils-cli-v1.27.3-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "b61eaa0981d5bda1b18cdf69f700a9dda07b55ed94d8dfbc61ed0d08b26923bc"
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
