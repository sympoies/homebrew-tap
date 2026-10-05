class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.31.22/nils-cli-v1.31.22-aarch64-apple-darwin.tar.gz"
      sha256 "7cbc0b38378ce5b79feaf11f503b708030629663862783009c2919e3fc8b34b7"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.31.22/nils-cli-v1.31.22-x86_64-apple-darwin.tar.gz"
      sha256 "e13c33ec5407512feab44ec41f19b2f53439887a40339374a98036b25dbeafa7"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.31.22/nils-cli-v1.31.22-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "88205a72c7e6e54163bd8ab5e56be36b5a2521512724c5fb2c9f6cc7499be7aa"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.31.22/nils-cli-v1.31.22-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "08e1e099bba37012cf3b4cae14c01b1ba62fedb6ac73f0c0e54526ffae5c80a8"
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
