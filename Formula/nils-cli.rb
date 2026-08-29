class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.26/nils-cli-v1.27.26-aarch64-apple-darwin.tar.gz"
      sha256 "ef08784b82ad5b1e58b063e600d27b2b556c0d835c2d0944050d22335d41a44e"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.26/nils-cli-v1.27.26-x86_64-apple-darwin.tar.gz"
      sha256 "f74e3ae272750e95f64f18ee44a4e44d44ef531a443b63e46ae3d7ab240abd87"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.26/nils-cli-v1.27.26-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "e82ca584671749054d81c0760af75aafb13f7ebf10099e8f58e0e4d08bb2ef4a"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.26/nils-cli-v1.27.26-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "8e1d573db920bbc6eee02131e50f7d2605f23cd579f7136734127f4ca206af42"
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
