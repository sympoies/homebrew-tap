class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.33.17/nils-cli-v1.33.17-aarch64-apple-darwin.tar.gz"
      sha256 "bdf43ab126afcf501f8388bc410794699675bf8daf55b47b2127323b047e8110"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.33.17/nils-cli-v1.33.17-x86_64-apple-darwin.tar.gz"
      sha256 "df0ab4b1ddcaee4f2df44526515eb93395449e90242aa8d3da758c0f02fb5994"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.33.17/nils-cli-v1.33.17-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "8a19eb38732b9e3d3954eb0452b0ebc7988f3a641f9f47a87ad71d8b6c87dc40"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.33.17/nils-cli-v1.33.17-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "ebf4ae198ddcfb3cacb26e797c29ed7b71611eba0394ee181e9090eb30dd0483"
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
