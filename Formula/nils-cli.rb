class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.14/nils-cli-v1.27.14-aarch64-apple-darwin.tar.gz"
      sha256 "157f38e6b4b655867ea17ef503df0ce138366ff26afce0274435a4b975efaa65"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.14/nils-cli-v1.27.14-x86_64-apple-darwin.tar.gz"
      sha256 "2387f27bc29cf7ce201318a4bd05c7bbf518d250defbe46e8694240f9776274d"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.14/nils-cli-v1.27.14-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "d64806762544cb19fe4872255b56725442f67481eee760bf601c2fd54027424e"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.27.14/nils-cli-v1.27.14-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "349941aa80aa224294f02d531d8865b2a810249b35f37e2963a84d31b75004d4"
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
