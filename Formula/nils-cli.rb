class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.7/nils-cli-v1.28.7-aarch64-apple-darwin.tar.gz"
      sha256 "6dbd00f45e5c65daff11e40e34b6d147dfe7a6630bf5a7479927ebfbf895025f"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.7/nils-cli-v1.28.7-x86_64-apple-darwin.tar.gz"
      sha256 "4d09e556b9b5787bc005d710d9a77e62bc3aa02deb7a1390d3eda2c19c9080b6"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.7/nils-cli-v1.28.7-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "4e14c129e147d10445df8ffde547db544b63ef875cf4f39b4b03c28fc3d119f6"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.7/nils-cli-v1.28.7-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "5455778a1af255ffb9654e47a86f710c3398064efc621c386128f35e05768694"
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
