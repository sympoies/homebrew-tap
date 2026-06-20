class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.12.1/nils-cli-v1.12.1-aarch64-apple-darwin.tar.gz"
      sha256 "8b1d2579f199e2ab3f3f089d5b4997e4fb9e593dc44091816409377079f50003"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.12.1/nils-cli-v1.12.1-x86_64-apple-darwin.tar.gz"
      sha256 "45a58a9622d8fa918d42ab334a32f5c55b908b4c1562721a4137c6613fc0f995"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.12.1/nils-cli-v1.12.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "a3fb963aa296c414e7d63b9693163ba99fc03e0f86f87d09cb2f65253b7008ab"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.12.1/nils-cli-v1.12.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "778be5242578bc8925b8c229f7969760c742702d7515700a6aa7801dcdd99f50"
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
