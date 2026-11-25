class Duckdock < Formula
  desc "Run Claude Code, Codex and opencode sessions on your SSH hosts from one TUI"
  homepage "https://github.com/askrubberduck/homebrew-tap"
  version "0.6.0"

  # macOS gets the cask, whose app carries this binary. The urls stay outside on_linux: a formula
  # with no url on macOS fails to load, which breaks brew cleanup there.
  depends_on :linux

  on_intel do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.6.0/duckdock-linux-x64.gz"
    sha256 "7734714dca14c377206438fabb9586201cda245bab208791c6bda72bfcc8b2d8"
  end
  on_arm do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.6.0/duckdock-linux-arm64.gz"
    sha256 "584c57f8d7c2aba3f5575eae5ff56f2e181ad774d027cbe6be90088ff0e541d6"
  end

  # Builds `duckdock host add` copies to remote hosts; it looks in ../lib/duckdock.
  resource "darwin-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.6.0/duckdock-darwin-arm64"
    sha256 "7a4d1d7a8282c0cdf4124eb68c9d863991d90f7cb69020037fa3205d82078181"
  end

  resource "linux-x64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.6.0/duckdock-linux-x64.gz"
    sha256 "7734714dca14c377206438fabb9586201cda245bab208791c6bda72bfcc8b2d8"
  end

  resource "linux-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.6.0/duckdock-linux-arm64.gz"
    sha256 "584c57f8d7c2aba3f5575eae5ff56f2e181ad774d027cbe6be90088ff0e541d6"
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
