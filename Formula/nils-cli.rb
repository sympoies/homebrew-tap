class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.20/nils-cli-v1.28.20-aarch64-apple-darwin.tar.gz"
      sha256 "495f8263a99aa7fc792e01fa21e69be2b4b3af3697ec33e3b7c8d755df981c20"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.20/nils-cli-v1.28.20-x86_64-apple-darwin.tar.gz"
      sha256 "092ddb948723c0178463b9e7a11887c4e5006f1cd8453d00e384b48fc0505efc"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.20/nils-cli-v1.28.20-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "97cc86ca905aba812845d125be538d3e66f7afd01e645aa4023d05a8ffb773b8"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.20/nils-cli-v1.28.20-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "93b8a2c2e8117102f448a7f499e30c10dd6a767f9922d80ccdc0df60eff9f8d0"
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
