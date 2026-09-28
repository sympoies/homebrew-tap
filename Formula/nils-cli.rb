class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.29.3/nils-cli-v1.29.3-aarch64-apple-darwin.tar.gz"
      sha256 "710c2d1ce857aeed0c906e95bfd969edc9c242fdf162161b3b0d433b491c8e1f"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.29.3/nils-cli-v1.29.3-x86_64-apple-darwin.tar.gz"
      sha256 "ed98464be787a1463f118ec1b5edbd64aa657f919c53c538d065f6fc2d7ffeac"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.29.3/nils-cli-v1.29.3-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "ae35774fd450353d4bf03c8ac46f935c85b62eb74284ba0df0de73374c9fc2a1"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.29.3/nils-cli-v1.29.3-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "b682947586703312095ed692fc8d6a71be3c13cc7e5b20328d1ea297eaf741b0"
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
