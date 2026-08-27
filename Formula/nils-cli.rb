class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.15/nils-cli-v1.27.15-aarch64-apple-darwin.tar.gz"
      sha256 "5ac5d7d43b8a4e9fb9f5758b5d371bf14e3658f86292294ca22c62e99a81bc9a"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.15/nils-cli-v1.27.15-x86_64-apple-darwin.tar.gz"
      sha256 "60ad35a229982c1c6df5b3b99e87c8ed12f42a02ee7e372364ac4a8d4e45e12b"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.15/nils-cli-v1.27.15-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "6ccb34fde976616c120aadea926df6bd6de174fa27ee4a1a077b54e0c0d63ad2"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.15/nils-cli-v1.27.15-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "31565502290668882a2ea5604d5fff22248d687aef8987ad19b5db7ced465cab"
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
