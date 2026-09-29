class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.30.0/nils-cli-v1.30.0-aarch64-apple-darwin.tar.gz"
      sha256 "e2cc59999a258c710ef1c88d54e5a2063049b09743bed16b80076bf82a877b22"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.30.0/nils-cli-v1.30.0-x86_64-apple-darwin.tar.gz"
      sha256 "31a7733e594dbb49a8837f6418417722d3e2fbd6540181c2eb85816daa74777d"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.30.0/nils-cli-v1.30.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "bc76521923f181209bae290e31bfbc1229a7d8f883d320fa0a4cfdbbc11c210c"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.30.0/nils-cli-v1.30.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "3076728896fecc56d164b5307f5474d74eb9f35d26a7e705e1b8bc6ca435b6a4"
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
