class Duckdock < Formula
  desc "Run Claude Code, Codex and opencode sessions on your SSH hosts from one TUI"
  homepage "https://github.com/askrubberduck/homebrew-tap"
  version "0.2.103"

  # macOS gets the cask, whose app carries this binary. The urls stay outside on_linux: a formula
  # with no url on macOS fails to load, which breaks brew cleanup there.
  depends_on :linux

  on_intel do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.103/duckdock-linux-x64.gz"
    sha256 "bfe59a9083e0bf2c353a7faf9d960e8bdfe3fa06ba9935c44dd767e02c857b7e"
  end
  on_arm do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.103/duckdock-linux-arm64.gz"
    sha256 "81150d89dbb1df0546e127e03da8c6e85c180e68370fdd9b3e513771ef9a3c84"
  end

  # Builds `duckdock host add` copies to remote hosts; it looks in ../lib/duckdock.
  resource "darwin-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.103/duckdock-darwin-arm64"
    sha256 "89d195bc2852ffab927c18247d3f63ef0925cd5a7daa28ed0c7961b9dd77bd8e"
  end

  resource "linux-x64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.103/duckdock-linux-x64.gz"
    sha256 "bfe59a9083e0bf2c353a7faf9d960e8bdfe3fa06ba9935c44dd767e02c857b7e"
  end

  resource "linux-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.103/duckdock-linux-arm64.gz"
    sha256 "81150d89dbb1df0546e127e03da8c6e85c180e68370fdd9b3e513771ef9a3c84"
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
