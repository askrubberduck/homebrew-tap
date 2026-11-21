class Duckdock < Formula
  desc "Run Claude Code, Codex and opencode sessions on your SSH hosts from one TUI"
  homepage "https://github.com/askrubberduck/homebrew-tap"
  version "0.5.2"

  # macOS gets the cask, whose app carries this binary. The urls stay outside on_linux: a formula
  # with no url on macOS fails to load, which breaks brew cleanup there.
  depends_on :linux

  on_intel do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.5.2/duckdock-linux-x64.gz"
    sha256 "53eb747586de80ffe275db127e380b4abfd9d2a8bfb6c07ccd6268e716670f2f"
  end
  on_arm do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.5.2/duckdock-linux-arm64.gz"
    sha256 "5a670f16b847919c90ee5430f6c51afd6e1adb1e74055f3f75a6570d5ebf92c8"
  end

  # Builds `duckdock host add` copies to remote hosts; it looks in ../lib/duckdock.
  resource "darwin-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.5.2/duckdock-darwin-arm64"
    sha256 "5bdc4d95ce2749319777a4eda3a9309fd204bd858f22cc739a8777c30c09b33b"
  end

  resource "linux-x64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.5.2/duckdock-linux-x64.gz"
    sha256 "53eb747586de80ffe275db127e380b4abfd9d2a8bfb6c07ccd6268e716670f2f"
  end

  resource "linux-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.5.2/duckdock-linux-arm64.gz"
    sha256 "5a670f16b847919c90ee5430f6c51afd6e1adb1e74055f3f75a6570d5ebf92c8"
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
