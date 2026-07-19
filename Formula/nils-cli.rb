class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.24.2/nils-cli-v1.24.2-aarch64-apple-darwin.tar.gz"
      sha256 "a9a0c6e692f49d80aa137be666c18bc246d7aeb1ded5572cf36596e69461f512"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.24.2/nils-cli-v1.24.2-x86_64-apple-darwin.tar.gz"
      sha256 "3368b1b9fb3debb4f8da40b5bc305414009024bdb58083fce8e99d0367b9e0ea"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.24.2/nils-cli-v1.24.2-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "7e934d7c10052355f6dae0895fd8b079271e2aadf6929cf7c4afd2e5e5d3888b"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.24.2/nils-cli-v1.24.2-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "7e2dc9dc8bd537874bc4c6456ff6ae7e26535cc56f1ca614eb755c09444993a9"
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
