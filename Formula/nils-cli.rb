class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.13/nils-cli-v1.27.13-aarch64-apple-darwin.tar.gz"
      sha256 "e8d447fe1e967ed8a2b7586c4a73ae7c4cfff7f7456cebde5fd66e6de7e3c2d6"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.13/nils-cli-v1.27.13-x86_64-apple-darwin.tar.gz"
      sha256 "3860629fb14f3800a5e8890049089c45baf0d4985d158331eca103b8624108a7"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.13/nils-cli-v1.27.13-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "60a48465c622a3616a0c4342a1273c53c92c69dc5263ed4b05489917ba1c8c7b"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.13/nils-cli-v1.27.13-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "617d452481d4c992c0228684331d275c647096de94be8197f24cd5bdd2b527f4"
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
