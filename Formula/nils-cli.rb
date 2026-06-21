class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.14.0/nils-cli-v1.14.0-aarch64-apple-darwin.tar.gz"
      sha256 "3a9913951dc904fae3a9bedff090b33a29443986bd46327537e97653bca6f1cb"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.14.0/nils-cli-v1.14.0-x86_64-apple-darwin.tar.gz"
      sha256 "c049ff21b9ee9ebe2a6de1df4d756fa8ec55fef21cc5ebda55e38df316def95b"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.14.0/nils-cli-v1.14.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "94f316da4a66f6c81cd6c677acf2a283ea10d8e237444b0e35fea0b91d0c6bfb"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.14.0/nils-cli-v1.14.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "4e4188ca56a99fe558e3eea740217ddb2fb0201628561a305649c1370c44bab9"
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
