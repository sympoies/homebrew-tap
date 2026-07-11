class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.18/nils-cli-v1.21.18-aarch64-apple-darwin.tar.gz"
      sha256 "d1472dc890bbc2bb0360ba3590cec8e0f7794e0fdae08998f9064b8d9ebc6316"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.18/nils-cli-v1.21.18-x86_64-apple-darwin.tar.gz"
      sha256 "74126b32680759272f6869e196ae5484889ecbf7ee806452a89efe72481d02c3"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.18/nils-cli-v1.21.18-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "dfad8b2ad8da1faef8bbfdba340ea1615024b89a4076fb9f0475ab3081990333"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.18/nils-cli-v1.21.18-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "04ad28d61e4ed4d08613b20f41141af799329c99f4aa194c14d13c267f533702"
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
