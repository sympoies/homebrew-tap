class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.39.1/nils-cli-v1.39.1-aarch64-apple-darwin.tar.gz"
      sha256 "0282f991dbd58b357bdaaf494a9b2838e53d1ba7fba0295abeb1b6318caab430"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.39.1/nils-cli-v1.39.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "8f0832c61d772f5d75c32d88b429c6f9e05083a41e05982475d2b1fd896927bc"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.39.1/nils-cli-v1.39.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "1cda21dfae54fcdd6ff17761c90e9c8214f4925a8ec6b661adfc80f9bcbb1da7"
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
