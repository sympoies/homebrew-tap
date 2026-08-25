class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.10/nils-cli-v1.27.10-aarch64-apple-darwin.tar.gz"
      sha256 "eb0608772760241c65692299e086bb12d1a67e1fe84969009989cae41b996472"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.10/nils-cli-v1.27.10-x86_64-apple-darwin.tar.gz"
      sha256 "865724204e65864bb23d9a57307df676228beea1b12d46081edbeea9de2b0de4"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.10/nils-cli-v1.27.10-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "f755d1c1514e6d0b6f22af3c7e7adb0473442b5c9802cfe13bc29775b96e4e27"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.10/nils-cli-v1.27.10-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "99769e39f2267a64885435ae81350df69bcdb78230659c17ff6d95459cb6ef2f"
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
