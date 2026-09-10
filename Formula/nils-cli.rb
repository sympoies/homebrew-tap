class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.16/nils-cli-v1.28.16-aarch64-apple-darwin.tar.gz"
      sha256 "65c1b15a17916c4cb4acf39c27aeb2bc571a3bfd550b22e9d409d716b07efeb5"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.16/nils-cli-v1.28.16-x86_64-apple-darwin.tar.gz"
      sha256 "ae13b6e604b5749064d60e579308a866644477f228726cd3c25d1d4f63a3f1d4"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.16/nils-cli-v1.28.16-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "886b9e5ce5a87ea6823227bc3ec058831801fd71e0cf03b89aa92a7083346b45"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.16/nils-cli-v1.28.16-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "02e471a577de1e8823f0c778b004e11d445f2abac35e564c41692625c5721ba6"
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
