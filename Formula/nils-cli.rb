class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.33.13/nils-cli-v1.33.13-aarch64-apple-darwin.tar.gz"
      sha256 "609f200a9fd00deb1b99315a704545f084a34424ce8dd4ff92e99d47ae4e07bd"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.33.13/nils-cli-v1.33.13-x86_64-apple-darwin.tar.gz"
      sha256 "dfae9c03673e719d1005bb69cf4557389b337be746403a118ca33ddd9b78a0f7"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.33.13/nils-cli-v1.33.13-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "904656b605b8e2a8b309fc86a05683651acbc571c187082f30728562bdc8b186"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.33.13/nils-cli-v1.33.13-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "8d925c3c3a707f3e84d604affe0f61d8ba4f79131a059e4a28f55a1bf495e640"
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
