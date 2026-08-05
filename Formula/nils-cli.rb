class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.26.3/nils-cli-v1.26.3-aarch64-apple-darwin.tar.gz"
      sha256 "bb1fab3b60e753629cfab2f622a8ef0b992a504ca35d4451d71e4ef62f50d734"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.26.3/nils-cli-v1.26.3-x86_64-apple-darwin.tar.gz"
      sha256 "e1fead9bc42528013014032b33ccb070579be4fe037939ff936325123e5bedbd"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.26.3/nils-cli-v1.26.3-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "2f763d48d22050dad48b45ea82f2d061f43159e57db8d59f971529f8fc17ab7e"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.26.3/nils-cli-v1.26.3-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "cf5571813ad3c74a8925f4c9386431059bd640c3058e00534eb4042ebbe33cf9"
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
