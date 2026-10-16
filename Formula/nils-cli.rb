class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.36.1/nils-cli-v1.36.1-aarch64-apple-darwin.tar.gz"
      sha256 "12c82bd335870519178330d8d5d1defb37912921445a550e0a70001435c3018a"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.36.1/nils-cli-v1.36.1-x86_64-apple-darwin.tar.gz"
      sha256 "23eacea6c40e2169c3a7339da30b55c626a7428281efb527da7edce551d67da5"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.36.1/nils-cli-v1.36.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "9c812e605ba0bef1c49a6503954eb77b1c19046099ae8880d23b0b9584fd05e3"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.36.1/nils-cli-v1.36.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "5e4bc53b1e1e4adf6e00ad0935d0ad9473f025c896fe9ae41032555bd2a20717"
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
