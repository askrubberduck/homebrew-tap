class Duckdock < Formula
  desc "Run Claude Code, Codex and opencode sessions on your SSH hosts from one TUI"
  homepage "https://github.com/askrubberduck/homebrew-tap"
  version "0.2.112"

  # macOS gets the cask, whose app carries this binary. The urls stay outside on_linux: a formula
  # with no url on macOS fails to load, which breaks brew cleanup there.
  depends_on :linux

  on_intel do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.112/duckdock-linux-x64.gz"
    sha256 "3cf25115d7014b0112842e35cc30ef2445dbaf439713e7695d685a6703585b68"
  end
  on_arm do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.112/duckdock-linux-arm64.gz"
    sha256 "d40a035de9ff10d6a15839337a0715359dca72a031b222b136f267d0e7dbd902"
  end

  # Builds `duckdock host add` copies to remote hosts; it looks in ../lib/duckdock.
  resource "darwin-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.112/duckdock-darwin-arm64"
    sha256 "5342502374d2c6f2662594464a73c6d187f4cb4492b5338ccd024a6887acce94"
  end

  resource "linux-x64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.112/duckdock-linux-x64.gz"
    sha256 "3cf25115d7014b0112842e35cc30ef2445dbaf439713e7695d685a6703585b68"
  end

  resource "linux-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.112/duckdock-linux-arm64.gz"
    sha256 "d40a035de9ff10d6a15839337a0715359dca72a031b222b136f267d0e7dbd902"
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
