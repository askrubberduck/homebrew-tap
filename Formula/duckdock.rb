class Duckdock < Formula
  desc "Run Claude Code, Codex and opencode sessions on your SSH hosts from one TUI"
  homepage "https://github.com/askrubberduck/homebrew-tap"
  version "0.2.111"

  # macOS gets the cask, whose app carries this binary. The urls stay outside on_linux: a formula
  # with no url on macOS fails to load, which breaks brew cleanup there.
  depends_on :linux

  on_intel do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.111/duckdock-linux-x64.gz"
    sha256 "6e323ec418bf440afb4b71846fb41016d9e933afc03d7d98d490dbfc23f7abe2"
  end
  on_arm do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.111/duckdock-linux-arm64.gz"
    sha256 "965c479b85f73d92cd0e46855e943f97eb88cf676c093803b44a714cfcc2545c"
  end

  # Builds `duckdock host add` copies to remote hosts; it looks in ../lib/duckdock.
  resource "darwin-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.111/duckdock-darwin-arm64"
    sha256 "994ca016ddbb4bfb48ad9fc1ae82776241288641fff4c28222c0bd2a7154d82b"
  end

  resource "linux-x64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.111/duckdock-linux-x64.gz"
    sha256 "6e323ec418bf440afb4b71846fb41016d9e933afc03d7d98d490dbfc23f7abe2"
  end

  resource "linux-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.111/duckdock-linux-arm64.gz"
    sha256 "965c479b85f73d92cd0e46855e943f97eb88cf676c093803b44a714cfcc2545c"
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
