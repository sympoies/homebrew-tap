class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.37/nils-cli-v1.28.37-aarch64-apple-darwin.tar.gz"
      sha256 "7b673081d5fb90ceb07f282ebdab1ecb73b893bc96ac7051f6e0bdccb33cc85b"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.37/nils-cli-v1.28.37-x86_64-apple-darwin.tar.gz"
      sha256 "be76d8b62a36e737b157c6c5048a819a2c6584e349b1dd96115b1e43ac1b1976"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.37/nils-cli-v1.28.37-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "7d83751c9b8ae6d747a6b07266b541d73cca731c5c60629adc6b9b6110611eed"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.37/nils-cli-v1.28.37-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "5b585e3f309790be504e6f4d3926c9a1afc54c94f821103be390979e7902dc20"
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
