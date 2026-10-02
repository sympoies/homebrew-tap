class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.31.11/nils-cli-v1.31.11-aarch64-apple-darwin.tar.gz"
      sha256 "b4d3f1cdaf562d50e672e83c75bf6d37584a7e0dc3283fb55bd7658faa47b6fc"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.31.11/nils-cli-v1.31.11-x86_64-apple-darwin.tar.gz"
      sha256 "664c83510d340d6c9bd58019e622000d08c301b012b56b7e543e14364b962bda"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.31.11/nils-cli-v1.31.11-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "e9f3cd48e708578b6b696d5b3eda67fc2b4ebf6db4d1f1ef62c7e6dba12b005e"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.31.11/nils-cli-v1.31.11-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "cedb780c11ff23a4d154a765a702a4d5163aa897dffafd51127f67dd090bf43d"
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
