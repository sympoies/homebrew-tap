class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.18/nils-cli-v1.28.18-aarch64-apple-darwin.tar.gz"
      sha256 "e6253327e771c2c67fa7a2302f3cd89d87bf6bdc0a5a97e9e8d5f6ad929ae339"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.18/nils-cli-v1.28.18-x86_64-apple-darwin.tar.gz"
      sha256 "ea491bf871b6c987fb716af78536a01d4bb48ad98ca059f7c79b04907ed28734"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.18/nils-cli-v1.28.18-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "7026af2509166d376dc5aaa14c5374de1946519ab876c64c7fbdb50e13100e56"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.18/nils-cli-v1.28.18-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "b3abcead8d8e797241c010f2fa68c801517644bea561308f88b84f4ddaddb708"
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
