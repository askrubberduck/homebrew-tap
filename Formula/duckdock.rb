class Duckdock < Formula
  desc "Run Claude Code, Codex and opencode sessions on your SSH hosts from one TUI"
  homepage "https://github.com/askrubberduck/homebrew-tap"
  version "0.2.102"

  # macOS gets the cask, whose app carries this binary. The urls stay outside on_linux: a formula
  # with no url on macOS fails to load, which breaks brew cleanup there.
  depends_on :linux

  on_intel do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.102/duckdock-linux-x64.gz"
    sha256 "d36e970726213676b8c0c4ace82b48b1f7468d2fb1a1ad0d31a696247fa4e337"
  end
  on_arm do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.102/duckdock-linux-arm64.gz"
    sha256 "2ec52cd5edec7433e11d51732c6f24c16e35ffb818e527a36fc0d2b517269656"
  end

  # Builds `duckdock host add` copies to remote hosts; it looks in ../lib/duckdock.
  resource "darwin-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.102/duckdock-darwin-arm64"
    sha256 "7ae23f59af7aa92c15bebe9d7d75a0e31e778f10daa5ec3ad36e2b1587da7890"
  end

  resource "linux-x64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.102/duckdock-linux-x64.gz"
    sha256 "d36e970726213676b8c0c4ace82b48b1f7468d2fb1a1ad0d31a696247fa4e337"
  end

  resource "linux-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.102/duckdock-linux-arm64.gz"
    sha256 "2ec52cd5edec7433e11d51732c6f24c16e35ffb818e527a36fc0d2b517269656"
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
