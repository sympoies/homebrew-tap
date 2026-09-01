class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.30/nils-cli-v1.27.30-aarch64-apple-darwin.tar.gz"
      sha256 "1c970170df3d7094e0e219f4b3198d16bd74b173e519e401e496cbf4d7d74dd1"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.30/nils-cli-v1.27.30-x86_64-apple-darwin.tar.gz"
      sha256 "29ece8e2c48abc6fcabd81ed911a1d37722c1a8af9dc02e69ab46c236964af7d"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.30/nils-cli-v1.27.30-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "e5ecaf63b39705d3a8c7969e789bdf736f7060de5ef6fb468f6495e45604d700"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.30/nils-cli-v1.27.30-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "99bb2a0e6b585271f69a4e5b6ff5c506c4d27e734fbf8265108afe3c7c72a163"
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
