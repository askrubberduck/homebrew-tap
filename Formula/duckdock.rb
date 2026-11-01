class Duckdock < Formula
  desc "Run Claude Code, Codex and opencode sessions on your SSH hosts from one TUI"
  homepage "https://github.com/askrubberduck/homebrew-tap"
  version "0.2.80"

  # macOS gets the cask, whose app carries this binary. The urls stay outside on_linux: a formula
  # with no url on macOS fails to load, which breaks brew cleanup there.
  depends_on :linux

  on_intel do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.80/duckdock-linux-x64.gz"
    sha256 "72fde509109287c44db86631e871e5fbbf44bbfca9f2b0e3a0eacab5e1301ac3"
  end
  on_arm do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.80/duckdock-linux-arm64.gz"
    sha256 "4d27a0d71f9274d965ea552390bea8bcd6924c543c151d7f01b682fb9c238771"
  end

  # Builds `duckdock host add` copies to remote hosts; it looks in ../lib/duckdock.
  resource "darwin-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.80/duckdock-darwin-arm64"
    sha256 "e922fa7053224356e47055a7769bf8e28f53307570afba3e12cdd3f92e775b6b"
  end

  resource "linux-x64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.80/duckdock-linux-x64.gz"
    sha256 "72fde509109287c44db86631e871e5fbbf44bbfca9f2b0e3a0eacab5e1301ac3"
  end

  resource "linux-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.80/duckdock-linux-arm64.gz"
    sha256 "4d27a0d71f9274d965ea552390bea8bcd6924c543c151d7f01b682fb9c238771"
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
