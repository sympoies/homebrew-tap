class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.10/nils-cli-v1.28.10-aarch64-apple-darwin.tar.gz"
      sha256 "743bfb09971f169e42ae2d86f1c97d71566466350b128b8f8b4fada6c10420c7"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.10/nils-cli-v1.28.10-x86_64-apple-darwin.tar.gz"
      sha256 "7bf03bbdf7b7e93dda8f5d003684adc87751a32a066c66aa01fee05b586162cf"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.10/nils-cli-v1.28.10-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "2d882e2699f9dddc7511dc5c98838185c670c910e8c1d07b77682da13e2707b3"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.10/nils-cli-v1.28.10-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "1878090d120355623ead2a20000e224b3d890e9ae7cf381942dfe5d3e7894752"
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
