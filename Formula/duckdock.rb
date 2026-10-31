class Duckdock < Formula
  desc "Run Claude Code, Codex and opencode sessions on your SSH hosts from one TUI"
  homepage "https://github.com/askrubberduck/homebrew-tap"
  version "0.2.74"

  # macOS gets the cask, whose app carries this binary.
  depends_on :linux

  on_linux do
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.74/duckdock-linux-x64.gz"
      sha256 "e167fb2f62df7fd0da29a09ec50d89ebf6b30ea2fdb8b690e15224717602fc79"
    end
    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.74/duckdock-linux-arm64.gz"
      sha256 "b383be7f5dee0d95f1ea7eff22127895b5dab0f41e2ad8ca57f83d60188ea233"
    end
  end

  # Builds `duckdock host add` copies to remote hosts; it looks in ../lib/duckdock.
  resource "darwin-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.74/duckdock-darwin-arm64"
    sha256 "2e9bdbcfe2f2ed0ce8e39507bd07e682887249be0359869c950711425b4ea094"
  end

  resource "linux-x64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.74/duckdock-linux-x64.gz"
    sha256 "e167fb2f62df7fd0da29a09ec50d89ebf6b30ea2fdb8b690e15224717602fc79"
  end

  resource "linux-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.74/duckdock-linux-arm64.gz"
    sha256 "b383be7f5dee0d95f1ea7eff22127895b5dab0f41e2ad8ca57f83d60188ea233"
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
