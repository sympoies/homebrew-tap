class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.26.1/nils-cli-v1.26.1-aarch64-apple-darwin.tar.gz"
      sha256 "62c56a48308321ce4ae403810caeca620270131930b06e52073af1188f8b9c62"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.26.1/nils-cli-v1.26.1-x86_64-apple-darwin.tar.gz"
      sha256 "5fa2a5727f5f133759985174e12b067b477216e99796b62cee57c62331995891"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.26.1/nils-cli-v1.26.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "935f92508dd518fc2c6b6d86c099704e465c7543ca8646a23e4cf7d5d5c7a76d"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.26.1/nils-cli-v1.26.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "71e83dd9a2ef0d0e8a9a52d8b1748e7cf6e3092ce2466092077f67f164969ab2"
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
