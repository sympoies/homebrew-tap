class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.45/nils-cli-v1.28.45-aarch64-apple-darwin.tar.gz"
      sha256 "554d10e047eb817d0f5e3af177256430e14d31402579ca4c160011dd1a4f67fc"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.45/nils-cli-v1.28.45-x86_64-apple-darwin.tar.gz"
      sha256 "76e7e26a7d65eb635bb7f79b745c450e8aa71898351bdb44209883ea127a3b8f"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.45/nils-cli-v1.28.45-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "69a292389555e930e2dac56fdfae7b539e1c5b1d96b819abb7a46cb873ea1a22"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.45/nils-cli-v1.28.45-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "bb2e47ab66f434d4bd2e4fedb085aeff9ae84ef1618856ab86e4d77e0fcf8a80"
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
