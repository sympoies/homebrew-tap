class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.22.2/nils-cli-v1.22.2-aarch64-apple-darwin.tar.gz"
      sha256 "933e18d697125d312c348bb8b7c26f3ec043e13923440ab053f495e9478b5538"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.22.2/nils-cli-v1.22.2-x86_64-apple-darwin.tar.gz"
      sha256 "cb231792324f71c61f265dfa88f26eea2b5dbd7baaf398bb5288f0a7fbc9527c"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.22.2/nils-cli-v1.22.2-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "ab82b96ab9dc2d2bae5c2222a7454f0ae8831edb1518d9a3904c3da5ee6c0279"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.22.2/nils-cli-v1.22.2-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "b7477018d7fac3816402e1e1071905ce2ad2f0fb30c55851e450e270156a317b"
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
