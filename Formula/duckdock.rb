class Duckdock < Formula
  desc "Run Claude Code, Codex and opencode sessions on your SSH hosts from one TUI"
  homepage "https://github.com/askrubberduck/homebrew-tap"
  version "0.2.109"

  # macOS gets the cask, whose app carries this binary. The urls stay outside on_linux: a formula
  # with no url on macOS fails to load, which breaks brew cleanup there.
  depends_on :linux

  on_intel do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.109/duckdock-linux-x64.gz"
    sha256 "908da817826048a61fbe664d495ec23ef395c74023ce793530e45364e2642ed5"
  end
  on_arm do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.109/duckdock-linux-arm64.gz"
    sha256 "aa4251ba87dac9a3cffab9143c38bd6d856edbb94956cfcf7e5ac2046c6e3907"
  end

  # Builds `duckdock host add` copies to remote hosts; it looks in ../lib/duckdock.
  resource "darwin-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.109/duckdock-darwin-arm64"
    sha256 "6b1bcdc2bf2637e6fa9cdc922c2ced32d9a94ef93de12977a1f4be20bc70410b"
  end

  resource "linux-x64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.109/duckdock-linux-x64.gz"
    sha256 "908da817826048a61fbe664d495ec23ef395c74023ce793530e45364e2642ed5"
  end

  resource "linux-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.109/duckdock-linux-arm64.gz"
    sha256 "aa4251ba87dac9a3cffab9143c38bd6d856edbb94956cfcf7e5ac2046c6e3907"
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
