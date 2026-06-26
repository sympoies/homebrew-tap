class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.18.0/nils-cli-v1.18.0-aarch64-apple-darwin.tar.gz"
      sha256 "eb3983e400152827b379c0d5de60dd2726befbead7863322c1605cb3542d46c6"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.18.0/nils-cli-v1.18.0-x86_64-apple-darwin.tar.gz"
      sha256 "64df30acc3615b86754435dfe55f2aa5d00647ef58e7ac6d5420d95f84932be1"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.18.0/nils-cli-v1.18.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "498be125df83fe7d2ffaff9c84f6cc4681891dc3f96abd981a3ca3ea602b52f2"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.18.0/nils-cli-v1.18.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "da8885984ea57eb3460d6d5e3b5ad30a30fb7606d2848301a28a75fcd3fbe6cb"
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
