class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.24.3/nils-cli-v1.24.3-aarch64-apple-darwin.tar.gz"
      sha256 "383311c3b63765e17ab730e1e77f4154bb3bd01f8360642ed1b07804c878c5c1"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.24.3/nils-cli-v1.24.3-x86_64-apple-darwin.tar.gz"
      sha256 "0db63cf607b326460e792740cbcb95ffb90ce866ab9ecd50b6086a050d5ee31a"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.24.3/nils-cli-v1.24.3-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "e7a6037e695f847e3a900e5fd51493538f4caf2fce9855ba06a2379c8835332c"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.24.3/nils-cli-v1.24.3-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "a5e24f9fa4002b3decabe2ed010b406eaf086183cda826be7b9843eb793d55a5"
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
