class Duckdock < Formula
  desc "Run Claude Code, Codex and opencode sessions on your SSH hosts from one TUI"
  homepage "https://github.com/askrubberduck/homebrew-tap"
  version "0.2.77"

  # macOS gets the cask, whose app carries this binary.
  depends_on :linux

  on_linux do
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.77/duckdock-linux-x64.gz"
      sha256 "a187e0058793b1015eae3a6aa4e9c09d2bee3108d349c00a8b331b60b56eae01"
    end
    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.77/duckdock-linux-arm64.gz"
      sha256 "f7a9d2100f3cf93bdaa3df971bcd5eae7da297700a953fc50729283d306f69ff"
    end
  end

  # Builds `duckdock host add` copies to remote hosts; it looks in ../lib/duckdock.
  resource "darwin-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.77/duckdock-darwin-arm64"
    sha256 "2b95cfbdf222e6096ae490268cf776e83ca3375ca56dafd1f177e1702464f6c1"
  end

  resource "linux-x64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.77/duckdock-linux-x64.gz"
    sha256 "a187e0058793b1015eae3a6aa4e9c09d2bee3108d349c00a8b331b60b56eae01"
  end

  resource "linux-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.77/duckdock-linux-arm64.gz"
    sha256 "f7a9d2100f3cf93bdaa3df971bcd5eae7da297700a953fc50729283d306f69ff"
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
