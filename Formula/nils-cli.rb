class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.15.0/nils-cli-v1.15.0-aarch64-apple-darwin.tar.gz"
      sha256 "7b29f5e9835c2c04a06b0c3254c1d40a004e3b4deb30c9748c6642bbb8cd8dfd"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.15.0/nils-cli-v1.15.0-x86_64-apple-darwin.tar.gz"
      sha256 "403525ee1eba94778f16d3d7fa9ca67af65e86092d5d8345989444d1683c3704"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.15.0/nils-cli-v1.15.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "48ecdfcbabf506db0faa29321a860795f2e8bcd003f7ddc0e32a886685e3b8e9"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.15.0/nils-cli-v1.15.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "c9d6a7765d02db4202a01d586e946b3a13154291ba451425ed2ca7e832491b4a"
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
