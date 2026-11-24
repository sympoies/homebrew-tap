class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.42.7/nils-cli-v1.42.7-aarch64-apple-darwin.tar.gz"
      sha256 "4afbe7212d9a23447bf1197ff0f9bea99eabb3bde18507f0f4607ed337f11b4e"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.42.7/nils-cli-v1.42.7-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "3027e343be67f44fab601e008c73d694266d8e71f27832c8bd2a6cae614267cf"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.42.7/nils-cli-v1.42.7-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "40210d3d4af1b3c5e80de63a6423194996131a9a28a150ae49eafe31e502c13f"
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
