class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.31.26/nils-cli-v1.31.26-aarch64-apple-darwin.tar.gz"
      sha256 "ff5d8ae566115e862d0381b6e48f619c9246624d20e86d157ae6c3d58b02c27e"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.31.26/nils-cli-v1.31.26-x86_64-apple-darwin.tar.gz"
      sha256 "ddae0fa4b92788064cb38647c8a2d3bf62553fcbfe9a24de270d180d30da0fc6"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.31.26/nils-cli-v1.31.26-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "4e6d56a767adb22c9d2957507bbfad06e2ffb8ce3649110e61a9e89b6839e2a1"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.31.26/nils-cli-v1.31.26-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "e10f4327e3005933644f657c25627cdb7a615eca300fdfbef10c8fd7e50e7058"
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
