class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.23/nils-cli-v1.21.23-aarch64-apple-darwin.tar.gz"
      sha256 "4ad9c82f58f8d55fd3e3cb93f90c23f4986de40ec071704b46a182376c966f8f"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.23/nils-cli-v1.21.23-x86_64-apple-darwin.tar.gz"
      sha256 "cb166f431dc0a3e4a93cd4983c20253a354122db1b61cd110125adf54d5303d5"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.23/nils-cli-v1.21.23-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "b98d1460e766655736e85fd927e00eef5b8616a81c982966c1f35aff0ce60cf6"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.23/nils-cli-v1.21.23-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "b730b88740c2c3798d37cf0b42c602d7e2177c24e13f3646669ef30dfc809b20"
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
