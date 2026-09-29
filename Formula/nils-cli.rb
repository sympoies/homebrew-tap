class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.30.2/nils-cli-v1.30.2-aarch64-apple-darwin.tar.gz"
      sha256 "5c5e62c2e9e833da00c173f35d03467543c04ac82fc57ead92abebcfafb2507d"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.30.2/nils-cli-v1.30.2-x86_64-apple-darwin.tar.gz"
      sha256 "d957ca0f4ad7023d677b0b94c4de6f07d08c914ccf16eaa893053f1dab9abfc3"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.30.2/nils-cli-v1.30.2-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "3405032ffc109fec9c0273b5183bfffb7df796f2e473db8a7c0afd2b6f5160d9"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.30.2/nils-cli-v1.30.2-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "8e8d4c47cf0efde0e8bfa7cafd9b56d0c8d0547c3d18c15bf9267415454a7a87"
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
