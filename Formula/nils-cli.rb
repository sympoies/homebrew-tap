class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.44.0/nils-cli-v1.44.0-aarch64-apple-darwin.tar.gz"
      sha256 "c2846675056c0fe02f0370e811775a21358ffd019a937a7c538dc27c67d8de96"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.44.0/nils-cli-v1.44.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "988c020d4708ab8ecb39e01bc094f7b33ef0675ec97a8ad5d5dfbe4675a35a69"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.44.0/nils-cli-v1.44.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "32f9fcad07f8c5a04acd238f40e719a0f94b8c8f4bd6e361efdc21b909d79fa2"
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
