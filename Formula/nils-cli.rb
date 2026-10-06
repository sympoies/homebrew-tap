class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.31.24/nils-cli-v1.31.24-aarch64-apple-darwin.tar.gz"
      sha256 "e462b5bbdd4aa36439c32cf1926da6b12b94240f4ca04ffe9160818d025285e6"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.31.24/nils-cli-v1.31.24-x86_64-apple-darwin.tar.gz"
      sha256 "782e3da39d0a79c0df251d701c212bcdf1b8146a9ea9d2f35da86789bce9e130"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.31.24/nils-cli-v1.31.24-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "d542a0ce9d406c261137a066fa327e1e8746428ee6f79b6fed8ba7d75bf60925"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.31.24/nils-cli-v1.31.24-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "b6c74345bc4de1f55a42db13f59ac6942cb3a275690d5876ac2b1d89c5aed91c"
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
