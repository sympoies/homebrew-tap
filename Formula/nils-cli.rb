class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.27/nils-cli-v1.28.27-aarch64-apple-darwin.tar.gz"
      sha256 "03262f5695547dbde432c86fe6899974bd9f0efa5f5419d75f7cc968ee591208"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.27/nils-cli-v1.28.27-x86_64-apple-darwin.tar.gz"
      sha256 "fca0341cc4744d1e172a00300a59751f82282f2936fbba9e629b9c8f6180c847"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.27/nils-cli-v1.28.27-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "f21058541fa107aa41dbb45d9f04ce4e8cbeb30b617a1c21190d08d9e8cbbc16"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.27/nils-cli-v1.28.27-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "5427e681651e3384c3b8f379a65b5ce9f75e2c95f725c62be331ad8ea8b786e9"
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
