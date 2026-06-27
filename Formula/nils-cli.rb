class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.18.6/nils-cli-v1.18.6-aarch64-apple-darwin.tar.gz"
      sha256 "c3f6160eafa0f6938090f0ec55306f71431cffddef6931f83e21c40c1527d6d3"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.18.6/nils-cli-v1.18.6-x86_64-apple-darwin.tar.gz"
      sha256 "4707a0ee9d5f01f04c1e959c55e7b1c9492d090dc97d3999e96de2ba40e9493d"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.18.6/nils-cli-v1.18.6-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "e3b0aab663da1904fba0de5bde5f37aa618bf9db5c06cc0917bc3e01fcbeb0b0"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.18.6/nils-cli-v1.18.6-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "b1e2db1c8c825e4613384c11120b2a35d549ae0df893d623bfa7fe457d069493"
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
