class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.24.1/nils-cli-v1.24.1-aarch64-apple-darwin.tar.gz"
      sha256 "14276b78039f584d24f4aa1f555791552f054104f8113cc8910253f01d62c52d"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.24.1/nils-cli-v1.24.1-x86_64-apple-darwin.tar.gz"
      sha256 "856db77d85b2ae5ed89b0cb893f15d163e9b1bdf07a142d704d526aa02d2f5cf"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.24.1/nils-cli-v1.24.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "623dfb9c308b8984a18558d69080262c41e2b2d8648cecb1df777624f7eb5740"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.24.1/nils-cli-v1.24.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "faf1c157806e4f8856adeb790b308733dc3321136a5d1d329a081698f19f88b0"
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
