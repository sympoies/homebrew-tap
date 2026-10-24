class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.36.33/nils-cli-v1.36.33-aarch64-apple-darwin.tar.gz"
      sha256 "c676a8be94c000739c4091319e8d3a8d714fa88d27fa0386136d935f4bc7aeb9"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.36.33/nils-cli-v1.36.33-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "87202811efa26b27e746be60082026454175d661b2560c3540491a8d1ee358d8"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.36.33/nils-cli-v1.36.33-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "b8cceb08251f5b18caf4f135d28246409a2533077a37b871cd135ba04138e951"
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
