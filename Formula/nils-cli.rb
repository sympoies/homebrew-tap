class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.5/nils-cli-v1.28.5-aarch64-apple-darwin.tar.gz"
      sha256 "2be24e7c4fa132fbc612caa77b346f01d015965ac21ec8cb5c5473d65384942a"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.5/nils-cli-v1.28.5-x86_64-apple-darwin.tar.gz"
      sha256 "9350653518c20ad0c036e01e087591252762b743c7dc79c519eb7013b2ee407f"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.5/nils-cli-v1.28.5-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "4228bc14f638f9765b61bd35e79bb87a7ab619192eadee8044e6bc227744ce4f"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.5/nils-cli-v1.28.5-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "edffbc100c8a2bf8c203e70b70368779152159f314a44fb5894004b6f44a83f5"
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
