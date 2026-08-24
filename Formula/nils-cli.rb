class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.7/nils-cli-v1.27.7-aarch64-apple-darwin.tar.gz"
      sha256 "ff89c065555bf831254cafa4db4011087643edfbd2225eb69dd86998fd0eff4e"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.7/nils-cli-v1.27.7-x86_64-apple-darwin.tar.gz"
      sha256 "972512ec03c897ed67fdfa9b826ce4b3880e053cf1c12e4f444789e2c84ded6f"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.7/nils-cli-v1.27.7-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "bb6916bdce33e12bc80b3a4900851390a40f8b5302164c014f48d8ac54a1d6a6"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.7/nils-cli-v1.27.7-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "231c084c979e1a625fb172e91790f2fcce920cfa76f713cdf63b705a2e913f86"
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
