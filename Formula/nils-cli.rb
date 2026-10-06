class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.31.27/nils-cli-v1.31.27-aarch64-apple-darwin.tar.gz"
      sha256 "da5c083510408058292b6b339b552bf7cc9796a7532ac6da29f8d795e41f0756"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.31.27/nils-cli-v1.31.27-x86_64-apple-darwin.tar.gz"
      sha256 "181d9d6f04526a09525bbd3af283e07eadafea3ef190454f21d9143966e96d77"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.31.27/nils-cli-v1.31.27-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "2d7e89ce30cc0349048796572b17c01bd33ac35bb4085fa5c8ff27fe783062e3"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.31.27/nils-cli-v1.31.27-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "c4673b12cfda02756f062e6d2540c2be1c19b89db6ecf2bb26dadb2ecb6ca98e"
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
