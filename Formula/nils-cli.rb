class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.10/nils-cli-v1.21.10-aarch64-apple-darwin.tar.gz"
      sha256 "8981bbac0357dfa4ba0b74b8bc2c6a3bca7eb27d4d306f42d10cebd890b59042"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.10/nils-cli-v1.21.10-x86_64-apple-darwin.tar.gz"
      sha256 "bba85facefd0163b154b1843d10cf52db355db6cf177809e9c7e2ff9e7004ff1"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.10/nils-cli-v1.21.10-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "4fed551ea7cf08b9a947fca3c55241a29d0475dfd082bdaeb6ee2a4f00c45d55"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.10/nils-cli-v1.21.10-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "a172dc7bf5a70b9f25e698f81d5dc506a9d56a507f657a5d583e906ea89cf4e2"
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
