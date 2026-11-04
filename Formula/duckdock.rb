class Duckdock < Formula
  desc "Run Claude Code, Codex and opencode sessions on your SSH hosts from one TUI"
  homepage "https://github.com/askrubberduck/homebrew-tap"
  version "0.2.88"

  # macOS gets the cask, whose app carries this binary. The urls stay outside on_linux: a formula
  # with no url on macOS fails to load, which breaks brew cleanup there.
  depends_on :linux

  on_intel do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.88/duckdock-linux-x64.gz"
    sha256 "06f29dbd7ec7285273602cfbdf54d267c8cd4fc2646eeb062152c1c63fc23d38"
  end
  on_arm do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.88/duckdock-linux-arm64.gz"
    sha256 "3f18cd887b829c3fed48956c90d42166c69deb3b50422383bcf9abe200bbaed4"
  end

  # Builds `duckdock host add` copies to remote hosts; it looks in ../lib/duckdock.
  resource "darwin-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.88/duckdock-darwin-arm64"
    sha256 "7968ff47a538e88ba8cf836898f9d778b8579c1c2022754f242a4e4942e24322"
  end

  resource "linux-x64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.88/duckdock-linux-x64.gz"
    sha256 "06f29dbd7ec7285273602cfbdf54d267c8cd4fc2646eeb062152c1c63fc23d38"
  end

  resource "linux-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.88/duckdock-linux-arm64.gz"
    sha256 "3f18cd887b829c3fed48956c90d42166c69deb3b50422383bcf9abe200bbaed4"
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
