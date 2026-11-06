class Duckdock < Formula
  desc "Run Claude Code, Codex and opencode sessions on your SSH hosts from one TUI"
  homepage "https://github.com/askrubberduck/homebrew-tap"
  version "0.2.93"

  # macOS gets the cask, whose app carries this binary. The urls stay outside on_linux: a formula
  # with no url on macOS fails to load, which breaks brew cleanup there.
  depends_on :linux

  on_intel do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.93/duckdock-linux-x64.gz"
    sha256 "70ae4a2a0d5fd61ee100f9e76ea2b89e7579fb8feacc005e5690772f45fcc983"
  end
  on_arm do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.93/duckdock-linux-arm64.gz"
    sha256 "256a8b6a532b6df2a60a0ab82866a47f1697f9484ccbb74999967ad101e73dc2"
  end

  # Builds `duckdock host add` copies to remote hosts; it looks in ../lib/duckdock.
  resource "darwin-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.93/duckdock-darwin-arm64"
    sha256 "596d5d17c00541bd451500b533a886428869b7786327a6a35ed88d54776f7aa8"
  end

  resource "linux-x64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.93/duckdock-linux-x64.gz"
    sha256 "70ae4a2a0d5fd61ee100f9e76ea2b89e7579fb8feacc005e5690772f45fcc983"
  end

  resource "linux-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.93/duckdock-linux-arm64.gz"
    sha256 "256a8b6a532b6df2a60a0ab82866a47f1697f9484ccbb74999967ad101e73dc2"
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
