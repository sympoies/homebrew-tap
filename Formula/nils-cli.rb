class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.40.13/nils-cli-v1.40.13-aarch64-apple-darwin.tar.gz"
      sha256 "e5a4de5528e544c2d122abf1a41d4d68cc1206202ef6c152e42f6f9ff4dca5fb"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.40.13/nils-cli-v1.40.13-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "473723a13876788271f6e23f6b743d50017a31bffc3a2b14338b23479ce67a85"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.40.13/nils-cli-v1.40.13-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "507ac0ba111727273d285bb3de3f1893a0de539d7910dafee8cd10354253b46f"
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
