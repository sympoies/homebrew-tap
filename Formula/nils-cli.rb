class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "direnv"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.33.5/nils-cli-v1.33.5-aarch64-apple-darwin.tar.gz"
      sha256 "c7bf07ff019bd76f78931c6f992a75d6072e378562ea69a280c22225c537b924"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.33.5/nils-cli-v1.33.5-x86_64-apple-darwin.tar.gz"
      sha256 "397d903e4a84a1ca5c818416ff37a4812a83bf2f477ce351040805b7d87c8f36"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.33.5/nils-cli-v1.33.5-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "89bbb166d30288f3d689e06f0ca8854d929cd594b1c7c4e774dccade1cabc940"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.33.5/nils-cli-v1.33.5-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "9899c66f98a38b05325cc680483da27040a7ff1a2014cfc4bd41a8ff2517f4f3"
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
