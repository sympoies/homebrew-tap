class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.42/nils-cli-v1.28.42-aarch64-apple-darwin.tar.gz"
      sha256 "51ca5a2a58c72894abb38e01225449dbf2055b88a510bab105269ba2f6207e2a"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.42/nils-cli-v1.28.42-x86_64-apple-darwin.tar.gz"
      sha256 "1df321510f21f160477371eea8ca826c2b52044b26fa403ce92966cb5ebf6b49"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.42/nils-cli-v1.28.42-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "33dc81ae9d829763e475c51b9b0f7956eb962046875c46b374126d777eded82d"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.42/nils-cli-v1.28.42-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "8e3f0967aaae52372abc0021918df9ae7dca3c477971b6dc6eaab9a1584196f7"
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
