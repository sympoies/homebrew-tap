class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.33.14/nils-cli-v1.33.14-aarch64-apple-darwin.tar.gz"
      sha256 "a0a3523b950b2e1aae1deeb428cd41d5c14ebca977d229c5b78780560b706fac"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.33.14/nils-cli-v1.33.14-x86_64-apple-darwin.tar.gz"
      sha256 "c3eaad350de1afcf7e3228e987885a74f890dbff17b952465b4a708d9d7cc56b"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.33.14/nils-cli-v1.33.14-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "7c6fa9b843157812090d4571338be5c27023265f8db325f8ab95f033a371f206"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.33.14/nils-cli-v1.33.14-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "85f8a8d7dc2fc643405dadf442e4246b0877edfdbb6bcac95f07de074b91b96a"
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
