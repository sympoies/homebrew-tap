class NilsCli < Formula
  desc "Rust CLI bundle (git-scope, git-summary, api-rest, api-gql, api-test, ...)"
  homepage "https://github.com/sympoies/nils-cli"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.1.0/nils-cli-v1.1.0-aarch64-apple-darwin.tar.gz"
      sha256 "de3b8ae764046f2c8c5cef54bd045cc14c3c8e91326f4ed02e485300a238c148"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.1.0/nils-cli-v1.1.0-x86_64-apple-darwin.tar.gz"
      sha256 "e6ab402bae30567146440b61adb2adf09c012cb0dbb1903431ac74930761607b"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/sympoies/nils-cli/releases/download/v1.1.0/nils-cli-v1.1.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "523b30de6d74441f36f91428ba9e935a895cb9729ff65f61f54d2a5fd830bdeb"
    else
      url "https://github.com/sympoies/nils-cli/releases/download/v1.1.0/nils-cli-v1.1.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "b3299249212bcf3d245cf7814924ffdd4a6141c6cac90845dd94c402f732d4cc"
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
    end
  end
end
