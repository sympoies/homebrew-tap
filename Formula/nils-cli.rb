class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.36/nils-cli-v1.21.36-aarch64-apple-darwin.tar.gz"
      sha256 "bd6d811381c8d2f32a7f1d0e779961b5dc082dddf46c38355161c7590ffba129"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.36/nils-cli-v1.21.36-x86_64-apple-darwin.tar.gz"
      sha256 "791f000c8693bf9ec8b367a9bff1f33147e3b1610e4446dfc83a2ad33acfdac7"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.36/nils-cli-v1.21.36-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "94035d5747ef48ac3c2b944af27e55a706710feaaae84244bddfb304690bf3d6"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.36/nils-cli-v1.21.36-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "80aad6d4c87b3a13253c45da5e4c0aeba27dcb2609044ce4522850f8d244183d"
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
