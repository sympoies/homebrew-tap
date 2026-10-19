class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.36.13/nils-cli-v1.36.13-aarch64-apple-darwin.tar.gz"
      sha256 "6a4126b85caea15a7e8a8709aa26a0dc70b136af061d9b642b16e21c52bc0071"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.36.13/nils-cli-v1.36.13-x86_64-apple-darwin.tar.gz"
      sha256 "2cbdc670011fea53ec1955ea618be6ab7f30b1665eaad4f4442657d7a27ece2b"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.36.13/nils-cli-v1.36.13-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "bf79a2001f9ece62e795353c986d91a99592140dc020efb9db85a392d54a6457"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.36.13/nils-cli-v1.36.13-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "819d332f71b97f4c3f977efc6b6f4755e43038d06be2a9ff3e56a72e38167292"
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
