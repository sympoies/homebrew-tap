class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.36.6/nils-cli-v1.36.6-aarch64-apple-darwin.tar.gz"
      sha256 "bd3ab185aac561b7a9e64b41191a394bbc30369c7a6073cbbb6faaa9e7e66600"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.36.6/nils-cli-v1.36.6-x86_64-apple-darwin.tar.gz"
      sha256 "abb2cb8fb73922cee19b238a82f667246d807982658177348b727579899bcf7c"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.36.6/nils-cli-v1.36.6-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "55c178998ad8afff4ab163fa118dd723a07e00b08cc88c67bd4a820e8c9c4ad4"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.36.6/nils-cli-v1.36.6-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "90a54976d2a88bd438c1a03f33056e775669a5d7d72915652095b31558156523"
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
