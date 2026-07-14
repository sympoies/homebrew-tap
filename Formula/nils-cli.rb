class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.22.1/nils-cli-v1.22.1-aarch64-apple-darwin.tar.gz"
      sha256 "2824665609be42d58b834e76a759b1effb24785e03d3aa53567922ef335cc9a7"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.22.1/nils-cli-v1.22.1-x86_64-apple-darwin.tar.gz"
      sha256 "5c1b977aaf58efbf69f86698f46c9c4d5ae31a9b69375fd1a05b2166a70bb457"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.22.1/nils-cli-v1.22.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "2ec472890b789f85fcc0bf87d1410ecaa463cdd7aa2484013cde0b2142915c3e"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.22.1/nils-cli-v1.22.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "fc6b2da27f6f751e9123709b0b49fdb697f3e64e4001f6677081b337e6d7995b"
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
