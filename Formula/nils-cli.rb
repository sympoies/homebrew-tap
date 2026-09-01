class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.32/nils-cli-v1.27.32-aarch64-apple-darwin.tar.gz"
      sha256 "69c1c5e9195c59fdadaa9069a0d6a3908462cef52c79b0934bdf664e0353fc2c"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.32/nils-cli-v1.27.32-x86_64-apple-darwin.tar.gz"
      sha256 "3144066cb9e9eb7e22dcabbea97b71df0f35771f9fb18eff629949b2bf4885bd"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.32/nils-cli-v1.27.32-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "1c86a9fa85119d43a3611f7297b06b6e653b3cc8acd25773127c02c9131e4e64"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.32/nils-cli-v1.27.32-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "db0ef6c888574c0c4e538e96a9a1dfa8f7d23d9beceed7249b90b54061b8918c"
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
