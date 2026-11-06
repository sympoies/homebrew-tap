class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.40.10/nils-cli-v1.40.10-aarch64-apple-darwin.tar.gz"
      sha256 "36055faed4627f908892ed5e4573cb344a3242ad99fd3fdb9d73f6020c87bdc1"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.40.10/nils-cli-v1.40.10-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "a5fcb71c123f122006bf5e084051c0bac9bcdc7d6caf6d7123fcabc082e1c620"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.40.10/nils-cli-v1.40.10-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "69d8b3f19768511a660d26d67c30c607a4d4c160d1b46d51ca0ed0a69d70693d"
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
