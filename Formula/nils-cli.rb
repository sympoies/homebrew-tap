class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.36.30/nils-cli-v1.36.30-aarch64-apple-darwin.tar.gz"
      sha256 "defe962769e1680abf98ea7c6ed1fab566c81f83fdad515c7b488b23363792da"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.36.30/nils-cli-v1.36.30-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "ca4dccec905b0331bbc11555daa94a5f46d79c8e01e0e2610e464a2a972f7e09"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.36.30/nils-cli-v1.36.30-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "058c31ed1c87753121b5e5919c0aa7f62a7a3b28437d670f54748de4cd32f478"
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
