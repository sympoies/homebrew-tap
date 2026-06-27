class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.19.2/nils-cli-v1.19.2-aarch64-apple-darwin.tar.gz"
      sha256 "0ee9742619a3abe5f5b7e3a8733abfca30bb8c2956fac97018b7e511326e9fb9"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.19.2/nils-cli-v1.19.2-x86_64-apple-darwin.tar.gz"
      sha256 "4861211baf27ae6c081a15411526462f6deaaa4b0645bad12082a621dbaea70e"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.19.2/nils-cli-v1.19.2-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "39292bbe90ff59c10ec4e537e917fa88ac5ea49e235bcaf3fe3692ce5119552e"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.19.2/nils-cli-v1.19.2-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "f82f298541a14e38de512f458841a7c4185528f111c94ecac50d87a0a1a33c04"
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
