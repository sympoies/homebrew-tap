class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.20.3/nils-cli-v1.20.3-aarch64-apple-darwin.tar.gz"
      sha256 "6febc3401cb75aafd4231c5830a15c1775f1edf4af383a3222e9f73941c1fb4c"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.20.3/nils-cli-v1.20.3-x86_64-apple-darwin.tar.gz"
      sha256 "3b716818f75bf6aa326fc1d6aa0ebc73f41efd62fc81f81ad854effbd9740746"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.20.3/nils-cli-v1.20.3-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "463f8330456839765db745fbe4685b4b04e78491e4d3e9b92036af64d60186b8"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.20.3/nils-cli-v1.20.3-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "b480944058c70a5a9ef20fcbbcba3cc8f2ef6487e14dced12222343e3060570e"
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
