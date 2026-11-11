class Duckdock < Formula
  desc "Run Claude Code, Codex and opencode sessions on your SSH hosts from one TUI"
  homepage "https://github.com/askrubberduck/homebrew-tap"
  version "0.2.101"

  # macOS gets the cask, whose app carries this binary. The urls stay outside on_linux: a formula
  # with no url on macOS fails to load, which breaks brew cleanup there.
  depends_on :linux

  on_intel do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.101/duckdock-linux-x64.gz"
    sha256 "85a24236e80967b942a6a6484e5b6fd49a9668cabbd86232fed1a5b1481e5cb2"
  end
  on_arm do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.101/duckdock-linux-arm64.gz"
    sha256 "82c029c1ddb70d630781c7efa3ad1730d76783a169e7e66fec0b1b71b4643f49"
  end

  # Builds `duckdock host add` copies to remote hosts; it looks in ../lib/duckdock.
  resource "darwin-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.101/duckdock-darwin-arm64"
    sha256 "f8c20a314930ffa7c844d5a6ff5c9d57ccee53fb2379c085ef3b1eb12b2a7165"
  end

  resource "linux-x64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.101/duckdock-linux-x64.gz"
    sha256 "85a24236e80967b942a6a6484e5b6fd49a9668cabbd86232fed1a5b1481e5cb2"
  end

  resource "linux-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.101/duckdock-linux-arm64.gz"
    sha256 "82c029c1ddb70d630781c7efa3ad1730d76783a169e7e66fec0b1b71b4643f49"
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
