class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.24.5/nils-cli-v1.24.5-aarch64-apple-darwin.tar.gz"
      sha256 "7413a730fe1bb8342922744a78c9d6e8710c84685fb2ade377b9926ee4998a1c"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.24.5/nils-cli-v1.24.5-x86_64-apple-darwin.tar.gz"
      sha256 "a890a0d4043a22bd51ae0fc96d8b6777c1968a08c8ff422b00cd55b153649b05"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.24.5/nils-cli-v1.24.5-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "97c35448cdd3f4a2f55821043b965e61c2a065631e61fc16cc6b6ea8718f0e48"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.24.5/nils-cli-v1.24.5-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "dd635e3d7932f5789eee9182ac0d2d540bc5a04e6b6e03b7d72b2c631423158c"
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
