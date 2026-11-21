class Duckdock < Formula
  desc "Run Claude Code, Codex and opencode sessions on your SSH hosts from one TUI"
  homepage "https://github.com/askrubberduck/homebrew-tap"
  version "0.4.0"

  # macOS gets the cask, whose app carries this binary. The urls stay outside on_linux: a formula
  # with no url on macOS fails to load, which breaks brew cleanup there.
  depends_on :linux

  on_intel do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.4.0/duckdock-linux-x64.gz"
    sha256 "9e18e891fa7f5ecad2bce0ec9620ef0d2d14cce78fe7b6e08f42465e5c2bd6d5"
  end
  on_arm do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.4.0/duckdock-linux-arm64.gz"
    sha256 "cdb2c9a4b10401ae7517d6e584f22537cef70840d4450dff5b1ce110e8709cb0"
  end

  # Builds `duckdock host add` copies to remote hosts; it looks in ../lib/duckdock.
  resource "darwin-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.4.0/duckdock-darwin-arm64"
    sha256 "d8eb8cb4a1e380d8ac4883184c3a4a1fa1323dbe5d1e2077a35857e9ad4f5de5"
  end

  resource "linux-x64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.4.0/duckdock-linux-x64.gz"
    sha256 "9e18e891fa7f5ecad2bce0ec9620ef0d2d14cce78fe7b6e08f42465e5c2bd6d5"
  end

  resource "linux-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.4.0/duckdock-linux-arm64.gz"
    sha256 "cdb2c9a4b10401ae7517d6e584f22537cef70840d4450dff5b1ce110e8709cb0"
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
