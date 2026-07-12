class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.21/nils-cli-v1.21.21-aarch64-apple-darwin.tar.gz"
      sha256 "0b24e3061c976e89580e0df9293747fd937f099497a2915cb7a18b6fdb0edd66"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.21/nils-cli-v1.21.21-x86_64-apple-darwin.tar.gz"
      sha256 "0053e5840d6bba0411fbfb59a9d63256127f5573aea5f7f09d71f8cef582b790"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.21/nils-cli-v1.21.21-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "98cfd9e25ae05d23020ea2b24925e4a902a0b33e278775f2fda0e172aa0b2dc0"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.21.21/nils-cli-v1.21.21-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "d0cd0978662e4f05742fe422b63c4bae7b3d87d98004d1f70e67f5da2fc30211"
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
