class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.39/nils-cli-v1.21.39-aarch64-apple-darwin.tar.gz"
      sha256 "141ef5ddc7498907c06453cff83588bb48703ae9c034f46a90a6daa90f608bb5"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.39/nils-cli-v1.21.39-x86_64-apple-darwin.tar.gz"
      sha256 "e3f9de88b44c47fad7e0beebed238557c6c24e70d17701432fb15a9d05c1d4b7"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.39/nils-cli-v1.21.39-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "3712b977a83a02dbdae10e8167ed80f480c629270015e1fdac8be78e1ba4169b"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.39/nils-cli-v1.21.39-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "9291f97a2f4ba3bd42efae3a77ea63b0a69079925cfd209d2b8307b84d893e63"
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
