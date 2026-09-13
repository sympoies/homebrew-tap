class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.24/nils-cli-v1.28.24-aarch64-apple-darwin.tar.gz"
      sha256 "011e8eeb46f3765e91d0ea59fb3acd38776c2b169ba7985a6e3e53c18d6e6d54"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.24/nils-cli-v1.28.24-x86_64-apple-darwin.tar.gz"
      sha256 "239ec3007beef6884d93afed0a45bb1d8862e45cdf77a9caad5aed632c622ad7"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.24/nils-cli-v1.28.24-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "1c321f4b457aa9f4edf9b6391642e45c4b29eb045373d0e5c351c5029096a44d"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.24/nils-cli-v1.28.24-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "5f8038d2a6ec4c0851e23f03d9a193bbf3d30c1774b74b3a9b2a2d0753bb0f1a"
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
