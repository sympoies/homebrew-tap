class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.36.26/nils-cli-v1.36.26-aarch64-apple-darwin.tar.gz"
      sha256 "37dc137b63d4680034cdd40debd7c81abfe81852401b25b9166b0b0ff8c21bef"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.36.26/nils-cli-v1.36.26-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "d0b6d5dc8ca7af7f1ae15b65fe3424dca9b1913ab3dd2a9b9c49d4116fdd6fa3"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.36.26/nils-cli-v1.36.26-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "118c37aae503f0b83c4a79cd586e6a63a12fd9376aa0d1ed873afb148df7c7db"
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
