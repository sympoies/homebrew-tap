class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.2/nils-cli-v1.28.2-aarch64-apple-darwin.tar.gz"
      sha256 "8e45b4876714d6b06de5220031beb5346e0aef9c63f474224bb14b59bd007ac0"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.2/nils-cli-v1.28.2-x86_64-apple-darwin.tar.gz"
      sha256 "bf74ef36495e0b148e5c7293827c2e4967ffd3925817eac2b2416054c66d408e"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.2/nils-cli-v1.28.2-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "2da58542edcf159495bc74c45c61c1df9dfd2471c101ec89b228caf73efefa86"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.28.2/nils-cli-v1.28.2-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "f01372304d7bc8eeb61ee22d326faf7b63062f6eb79dd92b64a477d226526c2b"
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
