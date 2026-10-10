class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.33.0/nils-cli-v1.33.0-aarch64-apple-darwin.tar.gz"
      sha256 "dc881f4b03cc59ed68970fddcdecd552fdf4886adf807c9e8df2738d60708fb0"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.33.0/nils-cli-v1.33.0-x86_64-apple-darwin.tar.gz"
      sha256 "8f7d0d4af16a0568a941144d30d4ae9e4f8e279b7057cf42c25b6433d0a93bf7"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.33.0/nils-cli-v1.33.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "f748a59e83e8e8596d36160ebf76e5df568070e6d839bfa4ca42b56d61494987"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.33.0/nils-cli-v1.33.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "3304183e9b4dc10f24bca34625188d1be1d2b4a03ba3d546fa8a530c32f941c4"
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
