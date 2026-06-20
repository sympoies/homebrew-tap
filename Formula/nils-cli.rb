class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.12.0/nils-cli-v1.12.0-aarch64-apple-darwin.tar.gz"
      sha256 "f22c33c55c50bc853e6a0244fd8718b50acca51bbf8c0a34e9ea818d4f5088cd"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.12.0/nils-cli-v1.12.0-x86_64-apple-darwin.tar.gz"
      sha256 "a602963adef4603638c60dcaee175bd5fb18a8fa68dd703f07ee51a4ec79a54e"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.12.0/nils-cli-v1.12.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "0f327262f7989584d233bee3e34818c433148fb791b6d7965936e8b9166c254a"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.12.0/nils-cli-v1.12.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "113928b0f3842a9410ed603889a80ab89e5f4891c72cdbbdb385f8a151376369"
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
