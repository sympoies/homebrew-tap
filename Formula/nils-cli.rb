class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.37.0/nils-cli-v1.37.0-aarch64-apple-darwin.tar.gz"
      sha256 "cf2b55d6e62b477797bddb2dd0e27dc291206326da0f6c8f5a20c10b8f5fe283"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.37.0/nils-cli-v1.37.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "70e1b5f9f79e4b2cf79c53e750d7f25d39878ad9eafdb2da6aede087e2838a96"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.37.0/nils-cli-v1.37.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "8b33db4a4c7e74b3621b0c25c85d8af9cf0231fd3be6bc9e92095c4089ea375d"
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
