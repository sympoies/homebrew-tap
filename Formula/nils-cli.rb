class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.36.3/nils-cli-v1.36.3-aarch64-apple-darwin.tar.gz"
      sha256 "bb73097f40a968b9769567db59715c9960a7a49629bfb20ed6d63b96093532aa"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.36.3/nils-cli-v1.36.3-x86_64-apple-darwin.tar.gz"
      sha256 "b8c105f5f0a1739e582d7f6cd61efa89c40032f28d226df04cec0736420775e9"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.36.3/nils-cli-v1.36.3-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "d1d179108f469342659f5c9ca6377c3282637ef59011903a89f5ca2bb67d7f08"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.36.3/nils-cli-v1.36.3-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "17a182277514c532ca51f4ee8dad3a958335376a3c8bb1c5aa716531d167e36a"
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
