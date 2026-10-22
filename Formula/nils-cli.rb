class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.36.23/nils-cli-v1.36.23-aarch64-apple-darwin.tar.gz"
      sha256 "1d54ee8081089fb117849dc28536967bb08ff0731d287ce553e7548b2b73ba70"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.36.23/nils-cli-v1.36.23-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "10ad4010eddd20bbef9ed8d495c7e0a0b3a79327f91266dea591167c97596c23"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.36.23/nils-cli-v1.36.23-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "affb37caf37c10c1f0e6a0107f690335c71e5463313def3ba450dfdb7996b50b"
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
