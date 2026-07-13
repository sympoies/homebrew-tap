class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.31/nils-cli-v1.21.31-aarch64-apple-darwin.tar.gz"
      sha256 "1d50d905b11989b35363f11b5805777b7073672448d37641cf24cf12fcf3bfac"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.31/nils-cli-v1.21.31-x86_64-apple-darwin.tar.gz"
      sha256 "526637e0a5d0fc65816b2d4ca6597493b34dcc27075a32183c70350c311cca38"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.31/nils-cli-v1.21.31-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "3d3c8d725a25d712bdf626f5367613d7d6e33c06b8050641719d72d23f3f7641"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.31/nils-cli-v1.21.31-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "1240f0d2a98335c5db6767810be521071cfe31ffb1099201de8c81743459c4f7"
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
