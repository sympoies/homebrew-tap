class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.52/nils-cli-v1.28.52-aarch64-apple-darwin.tar.gz"
      sha256 "4704d458ec6505a3d6021df8e5a0fe87e0133f89b9f2faee0be23fbe1ec5e25d"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.52/nils-cli-v1.28.52-x86_64-apple-darwin.tar.gz"
      sha256 "e955069393538cae554208866c7ad23a8c1bb8ff97b6427c06976819823671fc"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.52/nils-cli-v1.28.52-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "0117c8a6382580596bbe9506c845a4fcdd719a44e42dfa9fc7d9fd878660f70b"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.52/nils-cli-v1.28.52-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "102fa63367a96d4e1dfed69eb062f7cadae50b1104cb1a8d13290b7e59abb6aa"
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
