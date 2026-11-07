class Duckdock < Formula
  desc "Run Claude Code, Codex and opencode sessions on your SSH hosts from one TUI"
  homepage "https://github.com/askrubberduck/homebrew-tap"
  version "0.2.95"

  # macOS gets the cask, whose app carries this binary. The urls stay outside on_linux: a formula
  # with no url on macOS fails to load, which breaks brew cleanup there.
  depends_on :linux

  on_intel do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.95/duckdock-linux-x64.gz"
    sha256 "586e1e5043867a45c69808effe761e5388b30a7edd4833a14ff3fa9d43d6cfc8"
  end
  on_arm do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.95/duckdock-linux-arm64.gz"
    sha256 "22f4e6acf7c96c2ee30da4978fba5e192b3fe7863ae040884a9a5560a81d9543"
  end

  # Builds `duckdock host add` copies to remote hosts; it looks in ../lib/duckdock.
  resource "darwin-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.95/duckdock-darwin-arm64"
    sha256 "6392c732ed451ca1fbdc642b4775f1a512b39a643ed4b3451a445bc8c28d1c88"
  end

  resource "linux-x64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.95/duckdock-linux-x64.gz"
    sha256 "586e1e5043867a45c69808effe761e5388b30a7edd4833a14ff3fa9d43d6cfc8"
  end

  resource "linux-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.95/duckdock-linux-arm64.gz"
    sha256 "22f4e6acf7c96c2ee30da4978fba5e192b3fe7863ae040884a9a5560a81d9543"
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
