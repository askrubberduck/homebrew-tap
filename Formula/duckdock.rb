class Duckdock < Formula
  desc "Run Claude Code, Codex and opencode sessions on your SSH hosts from one TUI"
  homepage "https://github.com/askrubberduck/homebrew-tap"
  version "0.8.0"

  # macOS gets the cask, whose app carries this binary. The urls stay outside on_linux: a formula
  # with no url on macOS fails to load, which breaks brew cleanup there.
  depends_on :linux

  on_intel do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.8.0/duckdock-linux-x64.gz"
    sha256 "e4767da84a796ceb97767ffdce088d23d43e9b72324e9cbb0664c10e00cd7e55"
  end
  on_arm do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.8.0/duckdock-linux-arm64.gz"
    sha256 "35dac548e5feca57d463b3a6159ed80c9bd64ef40e6237a6439d9583a78daa22"
  end

  # Builds `duckdock host add` copies to remote hosts; it looks in ../lib/duckdock.
  resource "darwin-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.8.0/duckdock-darwin-arm64"
    sha256 "a612ff2d00f90ac2d65eb6f9348c38e297d5393c06e941193336f7dcc980dc99"
  end

  resource "linux-x64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.8.0/duckdock-linux-x64.gz"
    sha256 "e4767da84a796ceb97767ffdce088d23d43e9b72324e9cbb0664c10e00cd7e55"
  end

  resource "linux-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.8.0/duckdock-linux-arm64.gz"
    sha256 "35dac548e5feca57d463b3a6159ed80c9bd64ef40e6237a6439d9583a78daa22"
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
