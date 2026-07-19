class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.24.4/nils-cli-v1.24.4-aarch64-apple-darwin.tar.gz"
      sha256 "b2e3f1cb975c6d780bbcac9bba778d79da65b91b2734cb5531841c88973bd266"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.24.4/nils-cli-v1.24.4-x86_64-apple-darwin.tar.gz"
      sha256 "1d10dcd35d949f858c4ba6c5f06b6695a8447941bfcc30a355ab44733e2a9c34"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.24.4/nils-cli-v1.24.4-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "7aec6b47f6f6f7d0b76cadd42bf7e0aaf30d1e6e0559be9b3cfcfc06fb10bb9d"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.24.4/nils-cli-v1.24.4-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "b05fc0430c93579b59abeea6795fe84077cd136819df7e02eb178c726fb1f85e"
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
