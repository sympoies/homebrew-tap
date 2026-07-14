class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.35/nils-cli-v1.21.35-aarch64-apple-darwin.tar.gz"
      sha256 "58ab3ed73e8d1efd105b5938f82f66754f5d991bdb9d8b3d650eb98888188f89"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.35/nils-cli-v1.21.35-x86_64-apple-darwin.tar.gz"
      sha256 "74446fae03027ce4d69c702152d85012aea86ac85e02233307727ec83e3b9869"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.35/nils-cli-v1.21.35-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "5197501a8e4e76ef3e79b3ab7b4c120556bc37c6e013ca3327fe7fe919c6635f"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.35/nils-cli-v1.21.35-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "d675d38754166910675073c9f77233c0be5e3f12a86f08b29495726907dcfa17"
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
