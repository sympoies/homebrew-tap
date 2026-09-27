class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.29.0/nils-cli-v1.29.0-aarch64-apple-darwin.tar.gz"
      sha256 "d5a3e91653af35335bcb1fcab50bc69cfc0eebf277ce4c0c8c053c1441e80fa3"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.29.0/nils-cli-v1.29.0-x86_64-apple-darwin.tar.gz"
      sha256 "19ef1cd5dee46a4e9067f789f28b577e707b676d6839128f25f63cb190c17c37"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.29.0/nils-cli-v1.29.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "bd76fb437684d0abf591e5b2c764580a121998d68b91f6998ad5e0202ff4359f"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.29.0/nils-cli-v1.29.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "e22248809bfb6657d97b277725468ff152dad35ecd45af733d90e2764deca91b"
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
