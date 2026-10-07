class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.31.29/nils-cli-v1.31.29-aarch64-apple-darwin.tar.gz"
      sha256 "7b680087009ba84b1d38560ca66a0012c4939156224a0bd52e2cbac5a088693d"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.31.29/nils-cli-v1.31.29-x86_64-apple-darwin.tar.gz"
      sha256 "f6e06bec971d794a90ac8f545d24f59bcc4e49a705bb6ed612069460d1ca6c3a"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.31.29/nils-cli-v1.31.29-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "0bd3f4310f33d69511f7f5010b5e01e0dd88f54cb8ee2f727597c4a5f2bfaa69"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.31.29/nils-cli-v1.31.29-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "bf403801d2bce9367d6f1353cf2458f49d3b0426a1aba806269132b6532b7a27"
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
