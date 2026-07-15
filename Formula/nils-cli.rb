class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.22.5/nils-cli-v1.22.5-aarch64-apple-darwin.tar.gz"
      sha256 "99b1503a9681058006f83ed7b522d3c2afe1e6af8f4f28aca8e070d0b2adc89f"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.22.5/nils-cli-v1.22.5-x86_64-apple-darwin.tar.gz"
      sha256 "b3f54fb4e907cc8359e46a3ce98ba88c9d478a8b87aa1042f802aaf6d04de5a0"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.22.5/nils-cli-v1.22.5-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "6dae704298aaf0fb302911d89d83dac9d9376cfc9cb7fdff7319636119262973"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.22.5/nils-cli-v1.22.5-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "fbfc03b2bf9f9af77d11aa6ca02b82e5d4ccfc074dda1339f375417d2fd3fdf0"
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
