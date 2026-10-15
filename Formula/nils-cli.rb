class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.33.16/nils-cli-v1.33.16-aarch64-apple-darwin.tar.gz"
      sha256 "beaae3f2c0f8df21687158ca828b9c7a36b0f38796ce2bce3c365fb79eacb257"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.33.16/nils-cli-v1.33.16-x86_64-apple-darwin.tar.gz"
      sha256 "145befeb2cbfd30374d4a95143853dc3edd63e52419c10f8b42300ef2e1b4220"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.33.16/nils-cli-v1.33.16-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "4ff7b0a4837f002816087881bc0c3008cec6741edf8591452e73cb8b6031d63e"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.33.16/nils-cli-v1.33.16-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "0635f3e4daa2677dc2eed971231e231e4c902792feaccf3939daf0da4225e1d7"
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
