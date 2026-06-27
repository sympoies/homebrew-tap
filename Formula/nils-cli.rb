class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.18.7/nils-cli-v1.18.7-aarch64-apple-darwin.tar.gz"
      sha256 "b932481bfb808d991e1d81c120f619f306ce826669690fe6be9e2f1ff78c0fde"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.18.7/nils-cli-v1.18.7-x86_64-apple-darwin.tar.gz"
      sha256 "3b0e4bee62ac401e9289b6fad37f3bd9814dee8fdcff582b8d2950057688089f"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.18.7/nils-cli-v1.18.7-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "f57753aa2727ab121188a8da3b9f183db88662f253e9931461111bbaf184db75"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.18.7/nils-cli-v1.18.7-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "d8f072a4e0f7572873287025864804305ef30c4e4b76adcbee4d7cfa80dedc8a"
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
