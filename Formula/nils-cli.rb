class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.36.32/nils-cli-v1.36.32-aarch64-apple-darwin.tar.gz"
      sha256 "351d7e53f6101314f638dd93d3d2e2f6cf99262b6cb4a7734e9e5b0153fa1c81"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.36.32/nils-cli-v1.36.32-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "f0014ed45c1da75c1e9eb3db9fc690c40a59f03731447ea8c9666ab8fb267dee"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.36.32/nils-cli-v1.36.32-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "cdb47a8357241380b8eab9dbadeb850ba9fb22ebc89c3e8de4e623864a5bf9dc"
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
