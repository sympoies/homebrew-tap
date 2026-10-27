class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.36.40/nils-cli-v1.36.40-aarch64-apple-darwin.tar.gz"
      sha256 "c12bf0c50de7e51efa35e8598f1906e925724d7eb3d3b84c61cd61ea04c07754"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.36.40/nils-cli-v1.36.40-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "8d47a5e72b8cab078b85f7491647d62400bb45938cd3dfcebcb8b405b608cc69"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.36.40/nils-cli-v1.36.40-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "c8697a9a0d2bafe3a5ed0ba944606ec4642077709f70fe3a9c7cb9c385345e11"
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
