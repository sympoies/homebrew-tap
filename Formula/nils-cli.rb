class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.20.14/nils-cli-v1.20.14-aarch64-apple-darwin.tar.gz"
      sha256 "245c4228b9188ff02be1c83a39a594607d2a3416832e703dc48f5fc4ff9f1ac6"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.20.14/nils-cli-v1.20.14-x86_64-apple-darwin.tar.gz"
      sha256 "5c339019221e9449c6c85192dded22beef67b3524c4483f086a4f84493aaf6df"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.20.14/nils-cli-v1.20.14-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "38c74d7fa427d379ad21f190fe8713f72e1360fbd4db3b4680a68daed10c4009"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.20.14/nils-cli-v1.20.14-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "00bddd85acf72aab332691fdc76b2b2b5b662a04eef69f6cd91afff4dcc67796"
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
