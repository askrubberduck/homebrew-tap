class Duckdock < Formula
  desc "Run Claude Code, Codex and opencode sessions on your SSH hosts from one TUI"
  homepage "https://github.com/askrubberduck/homebrew-tap"
  version "0.2.79"

  # macOS gets the cask, whose app carries this binary. The urls stay outside on_linux: a formula
  # with no url on macOS fails to load, which breaks brew cleanup there.
  depends_on :linux

  on_intel do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.79/duckdock-linux-x64.gz"
    sha256 "2018e76b49821dbf9f8707327a94c06b546b9cecc5ec848f29d27afa80829aee"
  end
  on_arm do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.79/duckdock-linux-arm64.gz"
    sha256 "a0f52c024f996871f2e4607be35c828f0a869ab3efa0df580c1633c8cae344a8"
  end

  # Builds `duckdock host add` copies to remote hosts; it looks in ../lib/duckdock.
  resource "darwin-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.79/duckdock-darwin-arm64"
    sha256 "85a3f6226970489d2af24674d3e53d39cd19e90567691966cfb85995fee9e13f"
  end

  resource "linux-x64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.79/duckdock-linux-x64.gz"
    sha256 "2018e76b49821dbf9f8707327a94c06b546b9cecc5ec848f29d27afa80829aee"
  end

  resource "linux-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.79/duckdock-linux-arm64.gz"
    sha256 "a0f52c024f996871f2e4607be35c828f0a869ab3efa0df580c1633c8cae344a8"
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
