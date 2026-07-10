class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.6/nils-cli-v1.21.6-aarch64-apple-darwin.tar.gz"
      sha256 "7331a5a2116a321c308179d883af69fcfa0cca6f0ebcb4bfe59c6be708872395"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.6/nils-cli-v1.21.6-x86_64-apple-darwin.tar.gz"
      sha256 "f7c49910473469608074811985121c6fd4b9a301d9890668994df6c0a2ebb200"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.6/nils-cli-v1.21.6-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "232753fa6f18ffbe0f8d765d453259df4695f1f6e11b3cf68a6954d1f0ac9f92"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.6/nils-cli-v1.21.6-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "2ae7433838714234b041ddd2fb1b0979444a286cd2d2ee70bec1171e3d182b73"
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
