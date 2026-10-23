class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.36.27/nils-cli-v1.36.27-aarch64-apple-darwin.tar.gz"
      sha256 "bb0ff59477cc13f2e6c8cc7ecd450e8f25ee99eaecba8cdaf7c79082b58109a9"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.36.27/nils-cli-v1.36.27-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "3dab394cf52d78a64911da54961854ddef28a723d47ceea361f09f36d7e83021"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.36.27/nils-cli-v1.36.27-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "fd25e69a60649f7d13780ed6d02d92e308608fb4430fd9c78ad235622826a7aa"
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
