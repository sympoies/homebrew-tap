class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.21/nils-cli-v1.27.21-aarch64-apple-darwin.tar.gz"
      sha256 "639fd89ed339683adca415943d88fa31faa5410a5188a10a4b61f2d543922773"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.21/nils-cli-v1.27.21-x86_64-apple-darwin.tar.gz"
      sha256 "762f07b4e598dfa0b65fd05b459e5c41e52d3a4d9f9737a6927969e52d3d3d1a"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.21/nils-cli-v1.27.21-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "21c90f083271040a873f386b80b51dd788b80e8518ba26ac9af4eb41f2e73a85"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.21/nils-cli-v1.27.21-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "bd5dde2ab71964509a80d98d4258e0301b63c4b50de1e56d0d108d812e81e6fe"
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
