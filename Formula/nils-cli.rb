class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.9/nils-cli-v1.28.9-aarch64-apple-darwin.tar.gz"
      sha256 "0752dc3c6eb43492f1be305e4a87c9a95c839f8ca412eae5954aff8eb332b094"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.9/nils-cli-v1.28.9-x86_64-apple-darwin.tar.gz"
      sha256 "6a5405edeb2d7ec09893bf5f3cbc96e35d609874b537658eb63c2631d4744979"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.9/nils-cli-v1.28.9-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "744a9087d8ee792cec866170fda2cebb1cbb233ad27564815bba96c5f53db99a"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.9/nils-cli-v1.28.9-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "c97e30547caa8f67bc0f4ba4dfc9c6a0cbeaef902152de62d2d69c53a09f2156"
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
