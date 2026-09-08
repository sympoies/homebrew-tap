class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.8/nils-cli-v1.28.8-aarch64-apple-darwin.tar.gz"
      sha256 "2233fb785a59a7e8d15d9c4be1b4e8dd8c40a7ec69177d7d707c5052bf6bd763"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.8/nils-cli-v1.28.8-x86_64-apple-darwin.tar.gz"
      sha256 "c512974e2c235b0d3fd9c736e0fc6431e8c4601942ef9d7e4122f6f952b1ac62"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.8/nils-cli-v1.28.8-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "3b6912a458365d07ea06e6f133bd4ad64e01dce17c9c001c684d7a586be3d8a8"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.8/nils-cli-v1.28.8-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "730f92f34e4e95ce94b06c17f3cbe74607d66209d252d9f61a62e9ae63a2c00b"
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
