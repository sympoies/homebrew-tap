class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.25.9/nils-cli-v1.25.9-aarch64-apple-darwin.tar.gz"
      sha256 "0e8543e316bb58d2b71664a7a6d9e72e53f124239dc5b88c1c655dad5b61ae78"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.25.9/nils-cli-v1.25.9-x86_64-apple-darwin.tar.gz"
      sha256 "2ec94bbbf7149b1638f7fa17955954fc17adbaabec6cc5171a62b734a1edbf71"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.25.9/nils-cli-v1.25.9-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "949b13151162465926f54ef081fe412343fec2cdeb8cc28bd694eeace1d28dd6"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.25.9/nils-cli-v1.25.9-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "6bebf2a19fbc41a659afe95ead59b5880822a087872dc18b0e381cee0031b7c0"
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
