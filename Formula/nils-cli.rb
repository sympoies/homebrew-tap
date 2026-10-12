class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.33.7/nils-cli-v1.33.7-aarch64-apple-darwin.tar.gz"
      sha256 "1195ef41eb19f76369e853b944283352a073f5ab47f72ce88375be8a39843f27"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.33.7/nils-cli-v1.33.7-x86_64-apple-darwin.tar.gz"
      sha256 "445ec6e81ffafffbdfd1436bcb3aea47dd29a3d9d0c5b0454ddc04b290628f3e"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.33.7/nils-cli-v1.33.7-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "00a159a63ad24b90d506ea08282be7f3b082343c5a60400d5a431a709cd147ac"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.33.7/nils-cli-v1.33.7-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "6649f76a539796214ba64aa1ab3243207d579517859c138d5000d395aa4853aa"
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
