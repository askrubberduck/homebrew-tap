class Duckdock < Formula
  desc "Run Claude Code, Codex and opencode sessions on your SSH hosts from one TUI"
  homepage "https://github.com/askrubberduck/homebrew-tap"
  version "0.2.91"

  # macOS gets the cask, whose app carries this binary. The urls stay outside on_linux: a formula
  # with no url on macOS fails to load, which breaks brew cleanup there.
  depends_on :linux

  on_intel do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.91/duckdock-linux-x64.gz"
    sha256 "2185b737d0203214c95b9721c5f43510a75c7f860b576d3b5d5b597b9f4dd0f8"
  end
  on_arm do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.91/duckdock-linux-arm64.gz"
    sha256 "9c9dea8805c9b0d38646ee5a08ca42f8cb344b8548521d2dd785e755a443252e"
  end

  # Builds `duckdock host add` copies to remote hosts; it looks in ../lib/duckdock.
  resource "darwin-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.91/duckdock-darwin-arm64"
    sha256 "1ce1043a1c5dfb7caad19305883c53f62cccd5203ec59f2a8084dd6b8a766c00"
  end

  resource "linux-x64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.91/duckdock-linux-x64.gz"
    sha256 "2185b737d0203214c95b9721c5f43510a75c7f860b576d3b5d5b597b9f4dd0f8"
  end

  resource "linux-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.91/duckdock-linux-arm64.gz"
    sha256 "9c9dea8805c9b0d38646ee5a08ca42f8cb344b8548521d2dd785e755a443252e"
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
