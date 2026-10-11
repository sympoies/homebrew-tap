class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.33.4/nils-cli-v1.33.4-aarch64-apple-darwin.tar.gz"
      sha256 "ebff4c90f26b00492717f48dd980c08a57c99827df7dcd93e68539d1496d616a"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.33.4/nils-cli-v1.33.4-x86_64-apple-darwin.tar.gz"
      sha256 "ce0a8a3054f78c95022a9f15564130e3687cc52edf541b4c99c4e5cddc9395dc"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.33.4/nils-cli-v1.33.4-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "a943b56e420dab99ffdfeb0df14218a9ce6992a7da3f407f1fcbb71e2cda0369"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.33.4/nils-cli-v1.33.4-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "bc77cb3cda7dde4f85e7c43bc74fd19a108b5982204d3f4659f55d28e3235e8d"
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
