class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.41.3/nils-cli-v1.41.3-aarch64-apple-darwin.tar.gz"
      sha256 "d7cd8cd908ffa32329334f4e465ba6c4a1e83e2cb0939ec4ee41b5f1f797965c"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.41.3/nils-cli-v1.41.3-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "07325c4a1c8656c36b244e8068caea7bcf717b134357834a776cf68b90f1dc5e"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.41.3/nils-cli-v1.41.3-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "e7ad2661844d9c4754cd1adb13028002ab9f12e6f3dd1389e2f1180e02637150"
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
