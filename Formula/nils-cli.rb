class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.33.9/nils-cli-v1.33.9-aarch64-apple-darwin.tar.gz"
      sha256 "065385500523e34e4911a6c149b0b09db713a16a7f890999024bf88b5d4f141f"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.33.9/nils-cli-v1.33.9-x86_64-apple-darwin.tar.gz"
      sha256 "8d3e41d49af942deda318541df889fa8e0fee9d465daf3966d9cd94a146d5486"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.33.9/nils-cli-v1.33.9-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "42494c3154f4e0519551647e61af0f4eef708639f6f3fc43d626e2654979466d"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.33.9/nils-cli-v1.33.9-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "6266e70501c71d44c80cd865fb9d438d5d769eea7f9d471ee320c35cd64fe2d6"
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
