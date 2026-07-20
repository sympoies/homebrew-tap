class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.25.2/nils-cli-v1.25.2-aarch64-apple-darwin.tar.gz"
      sha256 "3d809c3e517481db25dc5bdb5268f96adc151b063b357c2f04170c048ef92beb"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.25.2/nils-cli-v1.25.2-x86_64-apple-darwin.tar.gz"
      sha256 "061892ba859c5eb16c84d7519005c5a3519c573e9971a904de12e53ff49b8698"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.25.2/nils-cli-v1.25.2-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "958c670a98f1af65cf8541cdb44e812c6c819533f603025b00558566f967634c"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.25.2/nils-cli-v1.25.2-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "ce499d472a91083d6aea9d1013f3e4bbe85c0810fa498dc73d01c7b1e37c6999"
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
