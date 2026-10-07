class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.32.1/nils-cli-v1.32.1-aarch64-apple-darwin.tar.gz"
      sha256 "3fe34aabb05cbca55bae84fab1421d6df825445053c5996722d7b949ba53da78"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.32.1/nils-cli-v1.32.1-x86_64-apple-darwin.tar.gz"
      sha256 "bc8cb76a67ab091945d4d5a9ae159fe2b0d6428abdfbfa779375fba5fe5ede82"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.32.1/nils-cli-v1.32.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "9218966ebfda1095cd1a32838417a63580f5fbd810ca4660e15dde293e3c9d1e"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.32.1/nils-cli-v1.32.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "e8b5be0e3cdd2a7a020da7dc433455b9df5f432e8ffa9f6b89866ea1aa964e7b"
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
