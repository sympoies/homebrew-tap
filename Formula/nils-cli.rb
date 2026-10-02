class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.31.12/nils-cli-v1.31.12-aarch64-apple-darwin.tar.gz"
      sha256 "715b75e246f6051b8b976eaabca20225d02dc6c0e2e6d1c3d46c4f2cbf7cba8a"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.31.12/nils-cli-v1.31.12-x86_64-apple-darwin.tar.gz"
      sha256 "d58c85105cc7c89787ce24a03f62772a7c3786b2331255cfb9f92763d36aae40"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.31.12/nils-cli-v1.31.12-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "74ebb8e9354858867e37b5000c9a605b1ba51879af04da1f8468eafbd87e764e"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.31.12/nils-cli-v1.31.12-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "4fe8b004cbc588196324e1dbc2099e19c60aded1d41a284e6126c963bc528a8e"
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
