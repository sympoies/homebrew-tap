class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.11.0/nils-cli-v1.11.0-aarch64-apple-darwin.tar.gz"
      sha256 "8b8e5b255a8f0a714cd47b78a1e6ab117b7a5a4be4e4aec1aff6f39cb8811211"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.11.0/nils-cli-v1.11.0-x86_64-apple-darwin.tar.gz"
      sha256 "b026cea0c254b6474bb5b04d98d878b6e447b2938afc9af420c95dec9dad1451"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.11.0/nils-cli-v1.11.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "b94b9c1ddacf9dcec382df51ef8cde8618e715bd88f3537b274cd3492e1013eb"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.11.0/nils-cli-v1.11.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "cb86fe9508d82261ef9f963a49bdc49702eea30e68a9de8f4012b4c851d19820"
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
