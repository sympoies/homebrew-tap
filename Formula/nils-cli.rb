class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.40.16/nils-cli-v1.40.16-aarch64-apple-darwin.tar.gz"
      sha256 "569c0042a0a30b9b16b244525df305ec857ac88f68f3221e875df8d28a963c50"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.40.16/nils-cli-v1.40.16-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "d79543a60714bd52ba9e610c4c528acebe566adbf5f15cf848a00471f858e37f"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.40.16/nils-cli-v1.40.16-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "d73db065ee90ed4cfa7611b635f15b76b2d66f7269c5978222a1964394162aa6"
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
