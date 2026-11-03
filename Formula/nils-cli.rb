class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.40.7/nils-cli-v1.40.7-aarch64-apple-darwin.tar.gz"
      sha256 "ab7b68c85f6f455f84d810081d2391091efdcaf04f99b98f22a8271d83a6cbd2"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.40.7/nils-cli-v1.40.7-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "9b2c5eed5007a838011ec7774c700ceb06c005c6f07127f7ebe7c78a010d005a"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.40.7/nils-cli-v1.40.7-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "0658121d103d2523910e408e438ac79dc8cb86e2421262814f24f7000039f326"
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
