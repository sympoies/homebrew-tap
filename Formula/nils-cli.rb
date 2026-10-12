class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.33.6/nils-cli-v1.33.6-aarch64-apple-darwin.tar.gz"
      sha256 "383b9bb15b812daa0ea0270088de7cb3b74136977711a7dc1b476be06e87b80d"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.33.6/nils-cli-v1.33.6-x86_64-apple-darwin.tar.gz"
      sha256 "4c659056f53fc1ca2d8b11f1e188f68873e8713ab402cb450691c926b6de89ed"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.33.6/nils-cli-v1.33.6-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "a8feb59a24f0cc19c0ae2163714a374712a2b25b9dcc27101307ab717bcec133"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.33.6/nils-cli-v1.33.6-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "5fc7b3737f079bfd87624b0c32373bd4d921130fd2d1146a0610248e2513ce9f"
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
