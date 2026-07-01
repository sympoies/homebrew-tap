class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.20.4/nils-cli-v1.20.4-aarch64-apple-darwin.tar.gz"
      sha256 "d56c8fe9295d3faa40daae7a7a0e24421ff771698f75b546ca58af0842189af1"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.20.4/nils-cli-v1.20.4-x86_64-apple-darwin.tar.gz"
      sha256 "7b014b0569477b2b80b45dae80a4edbd6bc6b1fa971bf50a0f143d5831b76c7d"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.20.4/nils-cli-v1.20.4-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "feb83115fec93e474437f142b88cc8c79a2d541ee1b076502485be4281d4b785"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.20.4/nils-cli-v1.20.4-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "9396558daf5558ee7b6250e4328ebbfc7a255ae8d0d00d29f1c85a2f53d42bfc"
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
