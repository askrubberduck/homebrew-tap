class Duckdock < Formula
  desc "Run Claude Code, Codex and opencode sessions on your SSH hosts from one TUI"
  homepage "https://github.com/askrubberduck/homebrew-tap"
  version "0.2.106"

  # macOS gets the cask, whose app carries this binary. The urls stay outside on_linux: a formula
  # with no url on macOS fails to load, which breaks brew cleanup there.
  depends_on :linux

  on_intel do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.106/duckdock-linux-x64.gz"
    sha256 "8d38bab758a4ca3867d19b7730956907854c0309ae7694b9b9cd6e1b78fe079e"
  end
  on_arm do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.106/duckdock-linux-arm64.gz"
    sha256 "acd7588963ebbc983464930621ad782ff31b70d39d96a398feac674800a1e375"
  end

  # Builds `duckdock host add` copies to remote hosts; it looks in ../lib/duckdock.
  resource "darwin-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.106/duckdock-darwin-arm64"
    sha256 "54dc2112c588c57e0fade8da50bd75d8b4108d06e0cefd2cc88b0c6c60d769c1"
  end

  resource "linux-x64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.106/duckdock-linux-x64.gz"
    sha256 "8d38bab758a4ca3867d19b7730956907854c0309ae7694b9b9cd6e1b78fe079e"
  end

  resource "linux-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.106/duckdock-linux-arm64.gz"
    sha256 "acd7588963ebbc983464930621ad782ff31b70d39d96a398feac674800a1e375"
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
