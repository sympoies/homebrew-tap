class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.34/nils-cli-v1.27.34-aarch64-apple-darwin.tar.gz"
      sha256 "9abc71134df9bdb04ff0a8d718fe91ad2e034c6f74b47c5af8d23a94735964e2"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.34/nils-cli-v1.27.34-x86_64-apple-darwin.tar.gz"
      sha256 "f50105b14c4f3356df9c068da0dbb759f4f346c56e90360ea13e4f02ae2e6f13"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.34/nils-cli-v1.27.34-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "436f2c3531721193a5c555f59bd7e01fd8a3e227e5785dd9534293c426e2a911"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.34/nils-cli-v1.27.34-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "a9c4a88038d66d538605fd1ded630fca342e1025372f24896254f4e34e5916a8"
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
