class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.36.12/nils-cli-v1.36.12-aarch64-apple-darwin.tar.gz"
      sha256 "d787dd148075dd557cf42210b0acfa06e7afcca690beff20a8baa1f600ead39f"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.36.12/nils-cli-v1.36.12-x86_64-apple-darwin.tar.gz"
      sha256 "50053fddfd8970c8fed1605246c6041b8e21b1292b0eff6379bd8ca68eca64cf"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.36.12/nils-cli-v1.36.12-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "50c9c2198b505f57881d4d89a18e895035733efbfb5d87a8f18f285d80e967e2"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.36.12/nils-cli-v1.36.12-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "a3be5df4d9df0789589aec97bb7e50dc82522f613d60afbbce5e80eddea266b6"
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
