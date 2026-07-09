class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.1/nils-cli-v1.21.1-aarch64-apple-darwin.tar.gz"
      sha256 "80a012777f853f49e0ab1b0dbc4d4af0a25644854809aad6f87dc78496745a46"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.1/nils-cli-v1.21.1-x86_64-apple-darwin.tar.gz"
      sha256 "76ca3cc59160ab14c40bcfb2583a6efd4760390d26e4c057b21e41ca6343f1f0"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.1/nils-cli-v1.21.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "18beef8c909c58cb21c7c97c1f497b2a2a1230311205a1c58c68df7461ae244b"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.1/nils-cli-v1.21.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "e17122fa202f7c1cc4d1413969e07308cb814dd55b4b3a7313d435b4996a8d9a"
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
