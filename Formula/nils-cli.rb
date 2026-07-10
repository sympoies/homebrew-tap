class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.9/nils-cli-v1.21.9-aarch64-apple-darwin.tar.gz"
      sha256 "28d7beaeac8dd1194d7950b73026e16093505d648b6cbc811cb112d902f4d385"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.9/nils-cli-v1.21.9-x86_64-apple-darwin.tar.gz"
      sha256 "e22a0c1e9ba1471ba5d3a84442eec40520255742c854e1da303b84f1eca9b801"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.9/nils-cli-v1.21.9-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "ab7c9f2a62399679c0868ef89074895fef1e9b59ca1e4268a7a119fc25075f18"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.9/nils-cli-v1.21.9-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "85ba6846ae68124e94079c756fa5320775c2c77d260b0408bac34726f6c32b88"
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
