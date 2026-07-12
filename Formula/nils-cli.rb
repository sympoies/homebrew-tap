class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.24/nils-cli-v1.21.24-aarch64-apple-darwin.tar.gz"
      sha256 "d224f8bb5bc25a27daf95c62402a6110bf547d5d67f7bbec2b3cf3531170a141"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.24/nils-cli-v1.21.24-x86_64-apple-darwin.tar.gz"
      sha256 "8d5af335ecd3da1dfd2ba140d17b9a1879ecce09f00a66834b12dbc34203bcaf"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.24/nils-cli-v1.21.24-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "bef39d14550506db4c68c751b0a79cc6e1b9f9c6b1e0c6c7b7330e00d2adedee"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.24/nils-cli-v1.21.24-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "815c416d0c57d7b113c9d18d069acd14bd13d397a0a6eb7e9111f91bade7e088"
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
