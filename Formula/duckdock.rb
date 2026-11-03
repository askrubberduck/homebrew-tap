class Duckdock < Formula
  desc "Run Claude Code, Codex and opencode sessions on your SSH hosts from one TUI"
  homepage "https://github.com/askrubberduck/homebrew-tap"
  version "0.2.85"

  # macOS gets the cask, whose app carries this binary. The urls stay outside on_linux: a formula
  # with no url on macOS fails to load, which breaks brew cleanup there.
  depends_on :linux

  on_intel do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.85/duckdock-linux-x64.gz"
    sha256 "2774f38ca8a865249f3f08f46df31d83f99eeb96a1c3b7ad6795558ad3d40a34"
  end
  on_arm do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.85/duckdock-linux-arm64.gz"
    sha256 "bcd6ff3c05045a40f5fb7c7be2f47c2ef9aa209eb579a2090aad5ae4b0a49bec"
  end

  # Builds `duckdock host add` copies to remote hosts; it looks in ../lib/duckdock.
  resource "darwin-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.85/duckdock-darwin-arm64"
    sha256 "62493f6f076cc3706882cbb8311bec449025f2cfff9f7b6bbcfa03fa496a29e1"
  end

  resource "linux-x64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.85/duckdock-linux-x64.gz"
    sha256 "2774f38ca8a865249f3f08f46df31d83f99eeb96a1c3b7ad6795558ad3d40a34"
  end

  resource "linux-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.85/duckdock-linux-arm64.gz"
    sha256 "bcd6ff3c05045a40f5fb7c7be2f47c2ef9aa209eb579a2090aad5ae4b0a49bec"
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
