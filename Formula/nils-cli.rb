class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.41.2/nils-cli-v1.41.2-aarch64-apple-darwin.tar.gz"
      sha256 "abff12e3ab57e5e102f4afa71133fa059d12aa820601f2797ebcb00138993890"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.41.2/nils-cli-v1.41.2-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "15fdc2ea5ef58cb7a9093d0c915e9790cf5fb7911b98a48124b184b3ed5e8983"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.41.2/nils-cli-v1.41.2-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "6717b37ad1fc8bbcdbcf2173a4bac03052de2d9040e56f58ac6817378dd1adc6"
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
