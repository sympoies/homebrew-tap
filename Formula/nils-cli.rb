class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.20/nils-cli-v1.27.20-aarch64-apple-darwin.tar.gz"
      sha256 "789071bea1268220b3735422df80d4de30cd4725e42f41fb6b045df9ae83a8a2"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.20/nils-cli-v1.27.20-x86_64-apple-darwin.tar.gz"
      sha256 "141dfd25d3869ac6a92b1578a68d67c6090702f36bf3dfe35720766c77b579b3"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.20/nils-cli-v1.27.20-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "9d09c579fd9036403c2295100b3f20d109c793d2f6d3d3dead2036ad0fecaaf8"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.20/nils-cli-v1.27.20-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "8954a0f33e7b85c576f42e658569d5bf2c16213b8ce5ab232665183908c86107"
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
