class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.20.11/nils-cli-v1.20.11-aarch64-apple-darwin.tar.gz"
      sha256 "a99f4f3b45842d149578bb8651ce2d92e638cb500949b154c5398978b34d06f1"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.20.11/nils-cli-v1.20.11-x86_64-apple-darwin.tar.gz"
      sha256 "723600668edfbd0abe64de9adf481bea7a2dc1178a739239488eec07fb29b4d0"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.20.11/nils-cli-v1.20.11-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "f74e3dc3103f2d372455a0036c67787170b35db220c5131d937f641b5406f314"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.20.11/nils-cli-v1.20.11-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "7f982f08cdf49b5e09226a88056ad1557805143a0cf42ce0f008680916a976ac"
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
