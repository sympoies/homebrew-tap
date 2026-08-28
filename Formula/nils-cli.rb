class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.24/nils-cli-v1.27.24-aarch64-apple-darwin.tar.gz"
      sha256 "6a4fa13a3737aaf6f9b47264c6c02db2a76051d064be3bf4ce46e2382e6cc4df"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.24/nils-cli-v1.27.24-x86_64-apple-darwin.tar.gz"
      sha256 "afabd4ac3dccace7bbe73cc65fe7b2b162705a91962916403c8da8b2a62e2d87"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.24/nils-cli-v1.27.24-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "4604af11a618b5b621946523b7a0f46c7a1612406e88d21fa6c1ef0d2d14c57d"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.24/nils-cli-v1.27.24-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "d3f641eb0b62edcc8b80a76be563e635f5ac42b8ad57d4bf91660e92efa532d6"
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
