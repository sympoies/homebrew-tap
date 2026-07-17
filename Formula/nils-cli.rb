class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.22.10/nils-cli-v1.22.10-aarch64-apple-darwin.tar.gz"
      sha256 "4a18b834ee3e4208d2c6cc045a5ae90ea395655d766e9a0b8d35d90dd44ddc5a"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.22.10/nils-cli-v1.22.10-x86_64-apple-darwin.tar.gz"
      sha256 "e4c601b363ba358a1b21f8967947654f38eb5851fe3977134eb70db31aac8040"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.22.10/nils-cli-v1.22.10-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "f9b93f8d164682fb70cac29534c7daa54d3cb69880f1d8cbe267a5e06628d2d5"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.22.10/nils-cli-v1.22.10-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "41a3c77fd6b63cbf366a8cf8194f4f118f9d5570d4875559c54cc405128a353d"
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
