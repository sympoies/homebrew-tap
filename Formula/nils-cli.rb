class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.9.4/nils-cli-v1.9.4-aarch64-apple-darwin.tar.gz"
      sha256 "62bbaee60ddd302774527e3e5e154a152f39f58bb0c8ee51be92bbac4b49ad51"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.9.4/nils-cli-v1.9.4-x86_64-apple-darwin.tar.gz"
      sha256 "1e2b6cd09c92328673981ca52231a907532db644c8f0e5e7f1ed551d5e2cbe90"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.9.4/nils-cli-v1.9.4-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "06006c1faa7ba3936d058acd5c66aff96dfd9e24c56d121f0282f7dd345675aa"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.9.4/nils-cli-v1.9.4-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "47725f313b72be9ade11f9eb5e827f4b8dbfecade66a33c5b55ea6813f76c98b"
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
