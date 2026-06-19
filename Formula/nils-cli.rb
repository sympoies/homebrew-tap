class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.9.6/nils-cli-v1.9.6-aarch64-apple-darwin.tar.gz"
      sha256 "b531ab774efcc2e6ffe29b8b295e6963aaf03d14e71315eeb111bbe07d8bd205"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.9.6/nils-cli-v1.9.6-x86_64-apple-darwin.tar.gz"
      sha256 "b63c18855c5fc2871634d375419cd10372f06b7f1552a6e66337984f003f8894"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.9.6/nils-cli-v1.9.6-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "6a1ac7105511ab5ead012daf634250bd77d1237b4cc01677100ae38d68bf4f63"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.9.6/nils-cli-v1.9.6-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "7245c4e7440f6f36b4d5f8ad590311a18ba2d35ce03a7bf81b8b7da7303e91ec"
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
