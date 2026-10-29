class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.39.0/nils-cli-v1.39.0-aarch64-apple-darwin.tar.gz"
      sha256 "d4368f35dc8b00f2bc5389160589d799a09064c590bec1f20b0e5d5642a94c8b"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.39.0/nils-cli-v1.39.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "c8f28d3ba885bb213cb4da322f3d893c9ba6136af5c73974076e0b5402323b92"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.39.0/nils-cli-v1.39.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "4f5f0f467c27cea3f4a43bcb51ea18db59651e9f76382afc231964d195af3863"
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
