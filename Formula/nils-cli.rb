class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.25.5/nils-cli-v1.25.5-aarch64-apple-darwin.tar.gz"
      sha256 "d4c82f87db3cc595116d79fcf508584d85fd91b6f38aa3a5f532e45aee758569"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.25.5/nils-cli-v1.25.5-x86_64-apple-darwin.tar.gz"
      sha256 "ba7f905fa59ae979c97799f2d2e70957ebb7555d98cc09c767030c77a70380ab"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.25.5/nils-cli-v1.25.5-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "29151b667d30f83caa558365cb3043eb98d40832f252a2248be23c65181b2be2"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.25.5/nils-cli-v1.25.5-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "5db8e4cbd0c6c3c229ada635da69685e58c99cc8fd72507a9a18dadfed1f6100"
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
