class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.15/nils-cli-v1.28.15-aarch64-apple-darwin.tar.gz"
      sha256 "8ad33586e9a8d9c7c6dc5b6b32eae348003ae7f9b7299ed9af2de3b6ff5b1a8b"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.15/nils-cli-v1.28.15-x86_64-apple-darwin.tar.gz"
      sha256 "7d66eba5b72e540cb174242c46ced4d8d721f5ffe083feb2f217c8402d08d92b"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.15/nils-cli-v1.28.15-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "5f946ec02e7d96dacbcf004d3404660a1daf67d91d659b652f6b8c4717b06b20"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.15/nils-cli-v1.28.15-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "68302b7d41de0a50f967e7dbc3f845571220195fe48c0d31394619e564e77d8a"
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
