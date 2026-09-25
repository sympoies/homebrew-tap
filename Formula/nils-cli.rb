class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.48/nils-cli-v1.28.48-aarch64-apple-darwin.tar.gz"
      sha256 "a146515aa411c2ee61b13919799aa71c1698f457dea836c79abac55cada63ff6"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.48/nils-cli-v1.28.48-x86_64-apple-darwin.tar.gz"
      sha256 "9b82d77bb8b6b18e8d6e2878efc02b51f3b28d0d7247d2ac498e2a6c4e2a1b92"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.48/nils-cli-v1.28.48-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "4c2c8b956096718160cfc73462c51d9160e4e24d6bde4ee28456d027de99d050"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.48/nils-cli-v1.28.48-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "66c6232b3069f94e95fd2b170466a356c79a5063a7b3c1ded8964d123bda83c6"
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
