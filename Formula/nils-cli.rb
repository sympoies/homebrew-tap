class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.20.6/nils-cli-v1.20.6-aarch64-apple-darwin.tar.gz"
      sha256 "184b710a6847a13fb3d624de7ef8a525e1da6e3d902c37da5e4da130c7b7ec97"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.20.6/nils-cli-v1.20.6-x86_64-apple-darwin.tar.gz"
      sha256 "e38a96eff536c122212558c829635fce63bb8a9f07c6cbbcb49d17bfc32ce910"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.20.6/nils-cli-v1.20.6-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "679b7449ab5283587c02c922d9bc94ba4da9f79ee2a84bbcfb0728da5a3aef42"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.20.6/nils-cli-v1.20.6-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "220186b7364dabf864e057f8e04b6c86fe79dd4fb546f5f144dfab533f979db9"
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
