class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.39/nils-cli-v1.28.39-aarch64-apple-darwin.tar.gz"
      sha256 "cc0c718079e9bf4ff5f0e49290d4604f76c2c6fb00a0714e29fdae8cb6ed03d8"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.39/nils-cli-v1.28.39-x86_64-apple-darwin.tar.gz"
      sha256 "f28c5ada4a8e85927afe3b51c5674c52456e0521c8e112a148cd805f1223d978"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.39/nils-cli-v1.28.39-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "7072b68a9ac73e36d05df32036f700e09d0be0f85900dcd9aadbc277db60c21b"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.39/nils-cli-v1.28.39-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "5c4657d9c9a336066963f269d20b5bec14b044941c941444ca3bdf7f083b5839"
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
