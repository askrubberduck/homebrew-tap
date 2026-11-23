class Duckdock < Formula
  desc "Run Claude Code, Codex and opencode sessions on your SSH hosts from one TUI"
  homepage "https://github.com/askrubberduck/homebrew-tap"
  version "0.5.6"

  # macOS gets the cask, whose app carries this binary. The urls stay outside on_linux: a formula
  # with no url on macOS fails to load, which breaks brew cleanup there.
  depends_on :linux

  on_intel do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.5.6/duckdock-linux-x64.gz"
    sha256 "2f383186ec6bb3b6c7c5b91227981904eb02af3498115b9ae5570cb34c819de9"
  end
  on_arm do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.5.6/duckdock-linux-arm64.gz"
    sha256 "9edf2aa4fbe300422731e4a06acd4310e1eef3d58994deeb1a21987dd8ad4398"
  end

  # Builds `duckdock host add` copies to remote hosts; it looks in ../lib/duckdock.
  resource "darwin-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.5.6/duckdock-darwin-arm64"
    sha256 "8e756155d97bd9455694e5700043617da3c6e577a75e6ecae64052b2fcc46a5e"
  end

  resource "linux-x64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.5.6/duckdock-linux-x64.gz"
    sha256 "2f383186ec6bb3b6c7c5b91227981904eb02af3498115b9ae5570cb34c819de9"
  end

  resource "linux-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.5.6/duckdock-linux-arm64.gz"
    sha256 "9edf2aa4fbe300422731e4a06acd4310e1eef3d58994deeb1a21987dd8ad4398"
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
