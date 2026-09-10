class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.17/nils-cli-v1.28.17-aarch64-apple-darwin.tar.gz"
      sha256 "930e5bbde745049150e0b8178efe004bfd2ec2dfb3d8a4feb04dfb23e488802d"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.17/nils-cli-v1.28.17-x86_64-apple-darwin.tar.gz"
      sha256 "93c5d4d88cb9e0cc2b87dd626c3af4596d207d53f617f1d565f9063f54956007"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.17/nils-cli-v1.28.17-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "dac7b8eebec1ccf81d92ca8f2ed35da4e49d8dc5882f38dd2c32b63f16fc4b4a"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.17/nils-cli-v1.28.17-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "7797043b398ea2dc21da3f581cc3cc740e084f3bfba3ab5cd139de91ef2bde42"
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
