class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.36.2/nils-cli-v1.36.2-aarch64-apple-darwin.tar.gz"
      sha256 "f195015b95ace989ea5cabcddd7ffaf2a03936b9a35f3cae58b54da84d72b397"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.36.2/nils-cli-v1.36.2-x86_64-apple-darwin.tar.gz"
      sha256 "6fa42a13e751d773d09bfc5539b85957f01930c16f8c17841696436effe24c7a"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.36.2/nils-cli-v1.36.2-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "9edd20a35f1647f45884b6e2ddd77dd1d0ef4186eeac7df66dd824494f9727fa"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.36.2/nils-cli-v1.36.2-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "b4a63ec6c8deb80fe6e1fcc8ca88579066b78bcd1397ec27469183775accbf85"
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
