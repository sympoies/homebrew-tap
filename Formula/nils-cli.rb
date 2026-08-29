class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.25/nils-cli-v1.27.25-aarch64-apple-darwin.tar.gz"
      sha256 "68eddf15bdaf8e9b914714e6c09ce77986780c3644eff92ca44c1dc3c6915d1e"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.25/nils-cli-v1.27.25-x86_64-apple-darwin.tar.gz"
      sha256 "e657b77ff4ccffe8f477fef2fc08777c6ccb9313a06399fb236613b2ab0d86e8"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.25/nils-cli-v1.27.25-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "b896815bf99741e38f60ac648bf0d0a8e998d7344e5d0e182f078811ad9171e5"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.25/nils-cli-v1.27.25-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "1b9638b26b289be94e9b98201688830b727a99d56c7965b3054a23cd9b64892f"
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
