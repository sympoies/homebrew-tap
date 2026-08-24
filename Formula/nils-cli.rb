class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.5/nils-cli-v1.27.5-aarch64-apple-darwin.tar.gz"
      sha256 "1dc6200608f1dfbf6ebf09de2c439142b7a9d1d482c347399e43efcafb28020c"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.5/nils-cli-v1.27.5-x86_64-apple-darwin.tar.gz"
      sha256 "1bdc240dcf1bd9ff9a88915e518ceaa05a18ba8565c6cb74f64d417868a533be"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.5/nils-cli-v1.27.5-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "aa9b7a4996cee4538e66f3bacf988aa4d5f57edebec27a632507b08ac46f8110"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.5/nils-cli-v1.27.5-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "132842847848d1d0e1506f4bce244cbd1388eb28a7852122b4e098d4c223d920"
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
