class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.1/nils-cli-v1.27.1-aarch64-apple-darwin.tar.gz"
      sha256 "f4cbebbb64aeb56b06c1e2cc73933a6d2af949536b575e0874194458276795c3"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.1/nils-cli-v1.27.1-x86_64-apple-darwin.tar.gz"
      sha256 "18bed51f27743c099c7682ed4089f8298b5fd8bdeedabe894e290357e599300f"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.1/nils-cli-v1.27.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "59b70e11db654769098f9de56ab7e0aa3b110781820e8a9dd35d89bf02589012"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.1/nils-cli-v1.27.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "db0bc121812f1e171029617fcd60d1930878baa350960ddf6bedbe2681740c9a"
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
