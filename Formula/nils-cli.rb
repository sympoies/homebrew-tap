class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.36.25/nils-cli-v1.36.25-aarch64-apple-darwin.tar.gz"
      sha256 "429d337d845ad416efe3cc4be4c3e97ac4c0fb86949180e9af1034f9f8129720"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.36.25/nils-cli-v1.36.25-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "cd912f83b6ff087aaad74a491eb6f5ab078a6fc4acf71d4a4e2dd82ba5cd4102"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.36.25/nils-cli-v1.36.25-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "3e6318084507feb0649e3a69795e92100e2c6637a127a67aedf4a79d5f3e5d1b"
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
