class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.39.8/nils-cli-v1.39.8-aarch64-apple-darwin.tar.gz"
      sha256 "aeee3e9f5d41815dd65a2590a38af87fd1fa4899f605bca4fc1c8d96b661cfde"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.39.8/nils-cli-v1.39.8-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "97d7475ee8b069ed261a6db9a58e34c324e0b06e80b2bbce4c28584579b89485"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.39.8/nils-cli-v1.39.8-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "515931dcb088379db26ad8c2fb6e90dbebc6536dc5fe97a2633ba98cd7069b6d"
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
