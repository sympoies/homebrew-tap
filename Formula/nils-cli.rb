class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.16/nils-cli-v1.27.16-aarch64-apple-darwin.tar.gz"
      sha256 "f0b53c439d2959ffacdde4d37abba1bc68f92d1bc40c8a14e1ca18888b2b8473"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.16/nils-cli-v1.27.16-x86_64-apple-darwin.tar.gz"
      sha256 "deeb95820941030e3ac713b309344a1e6ffe3d2209a59af482c1d16c8edc0c2f"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.16/nils-cli-v1.27.16-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "2e850c89f53fc7b0a8d346166346f1881f0bbb9a6ccddd155fb61a015b9ee06c"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.16/nils-cli-v1.27.16-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "ce9c840ebb1ac6d8addd45cdf1fc91b7ca192467b66f8caf5bd032bafc4c76b6"
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
