class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.35/nils-cli-v1.28.35-aarch64-apple-darwin.tar.gz"
      sha256 "7e8329a9013c42a7c7ea062a99fc3d83d861bbe59d025f419185fd78498eb0db"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.35/nils-cli-v1.28.35-x86_64-apple-darwin.tar.gz"
      sha256 "e0577d1facfbb4bb39a126b2646566523f29e490e3d37275fde3cbe69c6aefa1"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.35/nils-cli-v1.28.35-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "f3c6b338e51010309fc2ad0c97eaef1dcb978f16ea0fa81484c2e8d25897c8e2"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.35/nils-cli-v1.28.35-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "5b81a5426e1c698ba140ee175c8c9b033713cfe4d39743ec6503e01e2d7d6ec8"
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
