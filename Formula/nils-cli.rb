class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.19/nils-cli-v1.21.19-aarch64-apple-darwin.tar.gz"
      sha256 "5f4ee113beaeb215672b97566e102bd5b21ffece4c62b530d3bcc965e755d389"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.19/nils-cli-v1.21.19-x86_64-apple-darwin.tar.gz"
      sha256 "504dc4137f3f8109e7e2a9e9e82aa257aff2a25849b59eaf7c6bdf865194c2e2"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.19/nils-cli-v1.21.19-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "da1b815e3871bed348e0f8ae168fc65654afa7045f860c621b8ba4808fad1806"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.19/nils-cli-v1.21.19-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "a374d65e92183fb385818d625d35f410d9bd531c44ed9d32f1158430de3883f2"
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
