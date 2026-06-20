class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.13.0/nils-cli-v1.13.0-aarch64-apple-darwin.tar.gz"
      sha256 "127a315a697e36f55fdde99ee4771dd7fb092e1b2bea8c3571bebb0769b7be80"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.13.0/nils-cli-v1.13.0-x86_64-apple-darwin.tar.gz"
      sha256 "c314c2e48e5b7993269e51a03eedf6166375ea5a61685b1e6c2d52059cf9f6df"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.13.0/nils-cli-v1.13.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "bc8f5c6388044bd6a7d3232458c96ea2f27357cda13c77fba54f41972346931a"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.13.0/nils-cli-v1.13.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "0a7dbb026ac1ba785e37849f62ae50a213a29e7b7c4f36c3b9f9377f95e8e7c5"
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
