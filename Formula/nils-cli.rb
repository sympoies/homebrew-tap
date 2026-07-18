class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.24.0/nils-cli-v1.24.0-aarch64-apple-darwin.tar.gz"
      sha256 "4fb4829d233ed8c31720f61cd16cbce9dee9d99e3bf9328fba7cefc6a1b18bd2"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.24.0/nils-cli-v1.24.0-x86_64-apple-darwin.tar.gz"
      sha256 "65cb8e03c72be95edd45987762fa5a465120113a32ddc9383b876c64d45ac2ae"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.24.0/nils-cli-v1.24.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "3809f11aef516d3cbdff541bb77c941c18e8f9e06756685026424595e7979676"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.24.0/nils-cli-v1.24.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "d2a17a885716ca6984be23e3acf1b4b63c1f090a5211c883b63192694d0526ad"
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
