class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.25.3/nils-cli-v1.25.3-aarch64-apple-darwin.tar.gz"
      sha256 "3774ead18300f0905c62fd248dfcdf71ffe9a5dc6e8af24ebd84c3b3b5203b2d"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.25.3/nils-cli-v1.25.3-x86_64-apple-darwin.tar.gz"
      sha256 "dfc2709629be9d974d3b9570396134906a09abd0cffd900e8e6c833d2904d621"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.25.3/nils-cli-v1.25.3-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "1a9b816a9aee06e2b35c131b2dadbcf8e3e32b28ae73d399b0184654f7404edd"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.25.3/nils-cli-v1.25.3-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "dda8977f300264adc3323da6f1ca8fb7a8a500536ea11ddcf784e1fb64035b2c"
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
