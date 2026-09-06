class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.3/nils-cli-v1.28.3-aarch64-apple-darwin.tar.gz"
      sha256 "83214cd53b95196e4d3a346c6caddfa181225121b9c324e85b889d85fa283b44"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.3/nils-cli-v1.28.3-x86_64-apple-darwin.tar.gz"
      sha256 "8eae7bd325b2b48d8516b4469cef5d22c5850c08885537180709c37e636407a4"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.3/nils-cli-v1.28.3-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "22821fa844e08fff22f86090991b8e0ae7a676d2c30558c1cda2fb68938c0832"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.3/nils-cli-v1.28.3-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "b5cdc02deacc43cc1cad507ad6e9019d71d983fe508426ace4fa46ff4c2996b2"
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
