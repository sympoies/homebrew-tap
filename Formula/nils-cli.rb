class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.22/nils-cli-v1.28.22-aarch64-apple-darwin.tar.gz"
      sha256 "bc41ba851e1d488fd8fa279848b31e648e2128a49db8f19e98726244c7eb1b30"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.22/nils-cli-v1.28.22-x86_64-apple-darwin.tar.gz"
      sha256 "25a3490b0cc030aff98b36c887b08caa2d702ae4f47edb034061de9d7bb7846e"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.22/nils-cli-v1.28.22-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "cfb8af3fdbde1c4bf8156785562eca1ad7e18511a01518ba4b170d3895b4a5c3"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.22/nils-cli-v1.28.22-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "55bca2daa20bde359c61964f22740854c4dc90c08ca309bf184ccc819ea5c485"
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
