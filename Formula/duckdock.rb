class Duckdock < Formula
  desc "Run Claude Code, Codex and opencode sessions on your SSH hosts from one TUI"
  homepage "https://github.com/askrubberduck/homebrew-tap"
  version "0.2.118"

  # macOS gets the cask, whose app carries this binary. The urls stay outside on_linux: a formula
  # with no url on macOS fails to load, which breaks brew cleanup there.
  depends_on :linux

  on_intel do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.118/duckdock-linux-x64.gz"
    sha256 "86944e0c7e1aecd51a9d5ddf84391626f45a647612b21434b70033353ff0d230"
  end
  on_arm do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.118/duckdock-linux-arm64.gz"
    sha256 "f9460b6845c38a3cb3d76221ab3733204540d073a6153bcce7e73ecc15a39847"
  end

  # Builds `duckdock host add` copies to remote hosts; it looks in ../lib/duckdock.
  resource "darwin-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.118/duckdock-darwin-arm64"
    sha256 "2123244ae76e07283d134cdc9db5833302cedcbeb8338a2b636774bdbe0ba918"
  end

  resource "linux-x64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.118/duckdock-linux-x64.gz"
    sha256 "86944e0c7e1aecd51a9d5ddf84391626f45a647612b21434b70033353ff0d230"
  end

  resource "linux-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.118/duckdock-linux-arm64.gz"
    sha256 "f9460b6845c38a3cb3d76221ab3733204540d073a6153bcce7e73ecc15a39847"
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
