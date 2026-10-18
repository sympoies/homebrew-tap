class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.36.10/nils-cli-v1.36.10-aarch64-apple-darwin.tar.gz"
      sha256 "fdc1520ee0a8dce7491ef291d694f59f9e8979ad874b1cba2790f89e3c365d44"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.36.10/nils-cli-v1.36.10-x86_64-apple-darwin.tar.gz"
      sha256 "d0fa98d73b5365f2ebba148642767e6b53e1885f190213ceeb7edd1e369294ca"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.36.10/nils-cli-v1.36.10-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "45041b62ca4c4d1e3cc891101badaf4631614823e37bd2aeb21ec51fe315e154"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.36.10/nils-cli-v1.36.10-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "c6ec0659480849563940725183db295ebf194101e8d1484b1bff309a63eca6f6"
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
