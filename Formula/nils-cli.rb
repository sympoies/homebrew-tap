class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.31.20/nils-cli-v1.31.20-aarch64-apple-darwin.tar.gz"
      sha256 "14d4ac55eb7ce3bdd292724ac06d277d6ed7ee9385a2e679c8b9c8626985850d"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.31.20/nils-cli-v1.31.20-x86_64-apple-darwin.tar.gz"
      sha256 "c5184b67e09e2fda6ae6f325a657d24dd26d2983718a12e57f97c123dd9eeb04"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.31.20/nils-cli-v1.31.20-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "252c170f266f2fb58f65bf84fae907fa0e4a9ad9953e7b963d3e5a760da108f3"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.31.20/nils-cli-v1.31.20-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "ae5de7a3b0a4bc59978ce36622b234b85238f033644bf0289d40913d1fa8d30d"
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
