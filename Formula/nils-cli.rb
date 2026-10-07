class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.31.28/nils-cli-v1.31.28-aarch64-apple-darwin.tar.gz"
      sha256 "ac7e63208558206f82b8057fdfc87fc8edfd5c30ac1158ca2864ca36de6c3941"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.31.28/nils-cli-v1.31.28-x86_64-apple-darwin.tar.gz"
      sha256 "505f2679e013ca206fb2a310a3783c02c5e590af35395d4c3c7d75fd551df12f"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.31.28/nils-cli-v1.31.28-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "aaa60ab61de3e79c79489641d7e0844742ca7333dfaad214cb250705197ff7ae"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.31.28/nils-cli-v1.31.28-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "eb66ad081cef5574717cd05d30ecabee0bf4f4d5c24e8eaf7d239e67bd07c35f"
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
