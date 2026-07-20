class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.25.4/nils-cli-v1.25.4-aarch64-apple-darwin.tar.gz"
      sha256 "004805b262df54926a2a274be716ba0b8be9b052b73e2b0ce1abd2732c0484c0"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.25.4/nils-cli-v1.25.4-x86_64-apple-darwin.tar.gz"
      sha256 "d6305adb12b84e5824135b808018532429df1a4dd38ad1f6d80f076fbc987443"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.25.4/nils-cli-v1.25.4-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "a3cd75c0df2d8e0174603a8d17c36e5053f0684a5b7df36cc6ba29bc047140ed"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.25.4/nils-cli-v1.25.4-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "225ba126958c4420dc5eaad9fdc64b9a05f4525a3de7e4f5573ccaa9a24c10b7"
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
