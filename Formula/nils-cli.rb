class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.22.6/nils-cli-v1.22.6-aarch64-apple-darwin.tar.gz"
      sha256 "411d8c35731cf7f0f388bce5cc23aa18b43aa2a7aaf390295f5cbb47977b5718"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.22.6/nils-cli-v1.22.6-x86_64-apple-darwin.tar.gz"
      sha256 "8bdc41e7e8eb76e0319c73530f0b796d6c1f7d212587ccd33e0e3c3511de6169"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.22.6/nils-cli-v1.22.6-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "69ae6a0291765969d9b13ee072c294feab7cd66c0552caad4b54e2ad76088e5a"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.22.6/nils-cli-v1.22.6-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "ccd79e4ce8ce45e057e873ed9589792e7b32e552152192e401ff185823f3f1c3"
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
