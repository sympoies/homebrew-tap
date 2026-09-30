class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.31.1/nils-cli-v1.31.1-aarch64-apple-darwin.tar.gz"
      sha256 "44fe04e86db421ee75aa98081a60b29665fa8dfed1dc2d1bbfc2f8ca2b6ec358"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.31.1/nils-cli-v1.31.1-x86_64-apple-darwin.tar.gz"
      sha256 "4cd2d6cfb143c9c4332605bdc884cc4cf99102d9f89bcd1ec6715af49ad63caf"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.31.1/nils-cli-v1.31.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "537d3f063bd6e72813edeb0c23b6905af70de12893f0c0304dedef5676a66398"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.31.1/nils-cli-v1.31.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "02fd8807261a1ea35a3836873ee368d372de033168bf4075980977f753b5fa18"
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
