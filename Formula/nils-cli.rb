class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.40.8/nils-cli-v1.40.8-aarch64-apple-darwin.tar.gz"
      sha256 "aeded3cb9d35a2ebc7d9120fb62008072df9ed3d9e8640212d4264de682f5395"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.40.8/nils-cli-v1.40.8-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "a9356cf1ee2a8f6352d8794549287e317d2675c5dd44b90672c7ce92dc8fbf36"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.40.8/nils-cli-v1.40.8-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "bf70f1df4539e068622041c3747a362a05ccfeb3b9b75eb717297529930672b9"
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
