class Duckdock < Formula
  desc "Run Claude Code, Codex and opencode sessions on your SSH hosts from one TUI"
  homepage "https://github.com/askrubberduck/homebrew-tap"
  version "0.2.108"

  # macOS gets the cask, whose app carries this binary. The urls stay outside on_linux: a formula
  # with no url on macOS fails to load, which breaks brew cleanup there.
  depends_on :linux

  on_intel do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.108/duckdock-linux-x64.gz"
    sha256 "a5e6e42b671fbe4d0d50b757f7cc2558995d42509822f2775f4a4919ccd9497f"
  end
  on_arm do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.108/duckdock-linux-arm64.gz"
    sha256 "7fc29a9c081d132befbde097d007bc85b3d5b8ad818ed1b3f968931f7aafb9c9"
  end

  # Builds `duckdock host add` copies to remote hosts; it looks in ../lib/duckdock.
  resource "darwin-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.108/duckdock-darwin-arm64"
    sha256 "2cfaa0a44b392f4b81c76f13d909cb6023e5a9d02ca1fb7f7c36a94f3252c6aa"
  end

  resource "linux-x64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.108/duckdock-linux-x64.gz"
    sha256 "a5e6e42b671fbe4d0d50b757f7cc2558995d42509822f2775f4a4919ccd9497f"
  end

  resource "linux-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.108/duckdock-linux-arm64.gz"
    sha256 "7fc29a9c081d132befbde097d007bc85b3d5b8ad818ed1b3f968931f7aafb9c9"
  end

  def install
    # Raw download keeps its name; Homebrew gunzips the .gz ones to duckdock-linux-<arch>.
    bin.install Dir["duckdock-*"].first => "duckdock"
    chmod 0755, bin/"duckdock" # downloads and gunzip carry no exec bit
    %w[darwin-arm64 linux-x64 linux-arm64].each do |t|
      resource(t).stage { (lib/"duckdock").install Dir["duckdock-*"].first => "duckdock-#{t}" }
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/duckdock --version")
  end
end
