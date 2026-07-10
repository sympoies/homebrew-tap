class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.12/nils-cli-v1.21.12-aarch64-apple-darwin.tar.gz"
      sha256 "88c152a22bb5255bf801c725d7c5acb8423284224ed56040d38fab4530a64f95"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.12/nils-cli-v1.21.12-x86_64-apple-darwin.tar.gz"
      sha256 "14a933149cb3a636b79d7bbe73aaeadcb2de7c76a2b7a25b8de94fd89e54f6f9"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.12/nils-cli-v1.21.12-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "991b7050535908e206ea759e94ba967eea22221c3d4b75cd780494a59daa716d"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.12/nils-cli-v1.21.12-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "3d2350956a439910de0eca3db5e6423d622228795b06513125decddea7a10d08"
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
