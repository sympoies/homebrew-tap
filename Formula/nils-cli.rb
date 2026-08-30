class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.28/nils-cli-v1.27.28-aarch64-apple-darwin.tar.gz"
      sha256 "c5c8f94cb9039158ed224cac4d2bda1c69d968b507d315694ca7ecf55cf28329"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.28/nils-cli-v1.27.28-x86_64-apple-darwin.tar.gz"
      sha256 "1a53288304d3f4be51a7ceb9e67cdbe32dc826c2d965d03a9ee10f93d2362915"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.28/nils-cli-v1.27.28-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "51711496968b3d06746b49f5ca649e72b4edff15b68f561cec4b50cc3f408176"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.28/nils-cli-v1.27.28-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "6205f5a1ec4f67cea1caeb8e228b1b1d68634faf01c6d5b2ea1d6ab429dcc69f"
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
