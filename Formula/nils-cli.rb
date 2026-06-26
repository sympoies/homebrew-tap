class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.18.5/nils-cli-v1.18.5-aarch64-apple-darwin.tar.gz"
      sha256 "1fd1e90dc0e01cb2046fcc492cbca94b2664695c365371835ce9be86e84945f8"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.18.5/nils-cli-v1.18.5-x86_64-apple-darwin.tar.gz"
      sha256 "39d1c9bbbb2a34255173c104fbc31ea4528ee0c56973da55bafff120b0e931f9"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.18.5/nils-cli-v1.18.5-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "3ef8db11dbe4d1737700236c7cbc1db723616f01b88ba754c0b78aa2da807e33"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.18.5/nils-cli-v1.18.5-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "d91e84102e5d6ac24ed9a1da70daed01762b8c9bb90289846e6a7313ed14875d"
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
