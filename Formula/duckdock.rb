class Duckdock < Formula
  desc "Run Claude Code, Codex and opencode sessions on your SSH hosts from one TUI"
  homepage "https://github.com/askrubberduck/homebrew-tap"
  version "0.2.96"

  # macOS gets the cask, whose app carries this binary. The urls stay outside on_linux: a formula
  # with no url on macOS fails to load, which breaks brew cleanup there.
  depends_on :linux

  on_intel do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.96/duckdock-linux-x64.gz"
    sha256 "2e4e1e793e3018f45a1b740b90512a8d6c25482d4ff4893e9bc24ff5c5dd68e0"
  end
  on_arm do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.96/duckdock-linux-arm64.gz"
    sha256 "042a1ab1428b4d6bfe1f8ed3f2056adf0a2e8c316bfbea2d418a110133cf8e86"
  end

  # Builds `duckdock host add` copies to remote hosts; it looks in ../lib/duckdock.
  resource "darwin-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.96/duckdock-darwin-arm64"
    sha256 "92178515f9d50a8f7d2f9d291fa2330f63153a7ff6a843800a74415b81248bf4"
  end

  resource "linux-x64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.96/duckdock-linux-x64.gz"
    sha256 "2e4e1e793e3018f45a1b740b90512a8d6c25482d4ff4893e9bc24ff5c5dd68e0"
  end

  resource "linux-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.96/duckdock-linux-arm64.gz"
    sha256 "042a1ab1428b4d6bfe1f8ed3f2056adf0a2e8c316bfbea2d418a110133cf8e86"
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
