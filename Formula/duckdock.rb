class Duckdock < Formula
  desc "Run Claude Code, Codex and opencode sessions on your SSH hosts from one TUI"
  homepage "https://github.com/askrubberduck/homebrew-tap"
  version "0.7.0"

  # macOS gets the cask, whose app carries this binary. The urls stay outside on_linux: a formula
  # with no url on macOS fails to load, which breaks brew cleanup there.
  depends_on :linux

  on_intel do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.7.0/duckdock-linux-x64.gz"
    sha256 "96a816c4eff11b0d7693671e772722adb5cb91315a831ccfe30cd92616222260"
  end
  on_arm do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.7.0/duckdock-linux-arm64.gz"
    sha256 "04739d57282f0611dd250a3889cbcd245625879184b239d226e14064bd02a787"
  end

  # Builds `duckdock host add` copies to remote hosts; it looks in ../lib/duckdock.
  resource "darwin-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.7.0/duckdock-darwin-arm64"
    sha256 "0b8f27196423b2eb5ade323ff6fd68f129980b6a19903e5c2fa9c073b5fe5a58"
  end

  resource "linux-x64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.7.0/duckdock-linux-x64.gz"
    sha256 "96a816c4eff11b0d7693671e772722adb5cb91315a831ccfe30cd92616222260"
  end

  resource "linux-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.7.0/duckdock-linux-arm64.gz"
    sha256 "04739d57282f0611dd250a3889cbcd245625879184b239d226e14064bd02a787"
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
