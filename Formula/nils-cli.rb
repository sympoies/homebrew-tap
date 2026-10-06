class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.31.25/nils-cli-v1.31.25-aarch64-apple-darwin.tar.gz"
      sha256 "4171e04a4bd50f44665fb99479056781ce91db6f63c943886a0a770da883e6b6"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.31.25/nils-cli-v1.31.25-x86_64-apple-darwin.tar.gz"
      sha256 "393cc9071c0d71180290dd8a33a37c004aaebba2abe939d838dc1f08f4836cef"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.31.25/nils-cli-v1.31.25-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "c091772d0d091eaec7fa9adecd01d195eb85d4be571710bed58747e01863c547"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.31.25/nils-cli-v1.31.25-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "bf58bb5ff28ac31188f6b0206bd8ed3e39043536e19ec2a8ff91851e35a67c36"
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
