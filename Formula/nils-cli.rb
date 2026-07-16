class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.22.7/nils-cli-v1.22.7-aarch64-apple-darwin.tar.gz"
      sha256 "ba51978340507d79127946c484a28423decaf3d0470062e5ee8a43a542080b43"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.22.7/nils-cli-v1.22.7-x86_64-apple-darwin.tar.gz"
      sha256 "eec87bc71630d27551763208a780c436ca053f24eb73c15a9f132f2c2a78ef01"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.22.7/nils-cli-v1.22.7-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "465ff659eb5379a67195669544803af363ac5697cfffecb573d04e8bddc24528"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.22.7/nils-cli-v1.22.7-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "fdd6ca14e636ef577badbeee399d7449a95074ae117aa2c8be0b275a46efee61"
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
