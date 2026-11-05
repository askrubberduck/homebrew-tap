class Duckdock < Formula
  desc "Run Claude Code, Codex and opencode sessions on your SSH hosts from one TUI"
  homepage "https://github.com/askrubberduck/homebrew-tap"
  version "0.2.90"

  # macOS gets the cask, whose app carries this binary. The urls stay outside on_linux: a formula
  # with no url on macOS fails to load, which breaks brew cleanup there.
  depends_on :linux

  on_intel do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.90/duckdock-linux-x64.gz"
    sha256 "1256966dcb1cfc62fde7c0c5c7ac8948c536b6c033b8d58e88a7f38f2719cdab"
  end
  on_arm do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.90/duckdock-linux-arm64.gz"
    sha256 "444041626a8250e9480a6c4b72786969ba6a20006c0be53c428209fecf3dc242"
  end

  # Builds `duckdock host add` copies to remote hosts; it looks in ../lib/duckdock.
  resource "darwin-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.90/duckdock-darwin-arm64"
    sha256 "801f3127933f743ce1e071d346ec272716e805f1419e21b2c976e568c445c3fc"
  end

  resource "linux-x64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.90/duckdock-linux-x64.gz"
    sha256 "1256966dcb1cfc62fde7c0c5c7ac8948c536b6c033b8d58e88a7f38f2719cdab"
  end

  resource "linux-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.90/duckdock-linux-arm64.gz"
    sha256 "444041626a8250e9480a6c4b72786969ba6a20006c0be53c428209fecf3dc242"
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
