class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.22.8/nils-cli-v1.22.8-aarch64-apple-darwin.tar.gz"
      sha256 "ff5abf81ad9dc91c8cf4f593c4c9313b6f915f5145d18ff4656d6d93ccdae5ef"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.22.8/nils-cli-v1.22.8-x86_64-apple-darwin.tar.gz"
      sha256 "037218634be6ee595fe2e88552725271a01d5b93d7eb9e4afc02228a3d1fa23f"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.22.8/nils-cli-v1.22.8-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "c6817a08cd5b6f057ef8be4451def36c29a7a2536957cbe31abb49ad978b6fd3"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.22.8/nils-cli-v1.22.8-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "0e9f9519d09337cd35cafba31dad78160e1dd1aadc7ebaded9b8cb968379dafa"
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
