class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.33.8/nils-cli-v1.33.8-aarch64-apple-darwin.tar.gz"
      sha256 "9e94e5e7c0672077001e841d8323112f930f62465997a7c64f62e91692ad7f77"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.33.8/nils-cli-v1.33.8-x86_64-apple-darwin.tar.gz"
      sha256 "08fc4ec4bc8da7b4066e8c42b42ac3cda6e0fd8c8d7d1eafdb0a2b16a19ae2dd"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.33.8/nils-cli-v1.33.8-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "862fac746bf4e4bf078bf92c66ea3d34aaeeab36d0a3306d28ab64bb722b0226"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.33.8/nils-cli-v1.33.8-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "df202aebba74e9726a6aa40f7d7aca7bb3d89a264522e76ee2ef49d6cfe08d74"
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
