class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.36.24/nils-cli-v1.36.24-aarch64-apple-darwin.tar.gz"
      sha256 "70109556ad0f2cde844aedbc5d4ddf90bbb5cf354d80ac509634e916b2595f84"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.36.24/nils-cli-v1.36.24-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "5f9379ef52de94840165b8e99ffdd2ec448331b32afc31e012f7e9b2931edef4"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.36.24/nils-cli-v1.36.24-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "2f8abbf7427e54bd07e28d07c5c824cc472676e02c49a94d09f774b0f43e20eb"
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
