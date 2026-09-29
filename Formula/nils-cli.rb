class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.31.0/nils-cli-v1.31.0-aarch64-apple-darwin.tar.gz"
      sha256 "3511f8a7a415f6a7ec3f21450b19cb4954c13def1dd22057f0703def3bce6b9e"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.31.0/nils-cli-v1.31.0-x86_64-apple-darwin.tar.gz"
      sha256 "c7128d9c9565282f93e930734ca622211e4ec8ed69255cf62c5e47f5ec03522e"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.31.0/nils-cli-v1.31.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "2f5ee4019ab68526d731ca1e5ca71082e7075c98a4002b85560c196447b8210c"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.31.0/nils-cli-v1.31.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "d245c0a86dcc6a3575c8a5278599769b108c4b1167887a153cdde473f695fc9b"
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
