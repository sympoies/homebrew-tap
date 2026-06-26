class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.18.1/nils-cli-v1.18.1-aarch64-apple-darwin.tar.gz"
      sha256 "944c8d459e23a5b75cb7a9dacef72deb5a3aef9a7a29ed6ef47b4b9d24cbb116"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.18.1/nils-cli-v1.18.1-x86_64-apple-darwin.tar.gz"
      sha256 "00f080b8f6833c2e159234c2c65b09d9d1138ea1c96b417c8b47b46136240b71"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.18.1/nils-cli-v1.18.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "e4fbab27458509f0e4aa07eb8b3412f4afd52aa66ab9581e7f01ac397a9e3f2e"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.18.1/nils-cli-v1.18.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "e30b0a033f63019e70d1840c44554585c1b816852b0759c859ad63046a3499b8"
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
