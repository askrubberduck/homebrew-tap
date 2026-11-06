class Duckdock < Formula
  desc "Run Claude Code, Codex and opencode sessions on your SSH hosts from one TUI"
  homepage "https://github.com/askrubberduck/homebrew-tap"
  version "0.2.94"

  # macOS gets the cask, whose app carries this binary. The urls stay outside on_linux: a formula
  # with no url on macOS fails to load, which breaks brew cleanup there.
  depends_on :linux

  on_intel do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.94/duckdock-linux-x64.gz"
    sha256 "12e12afceb524d98ef38c593afc355e3be92a4b4cc96c8558e7d0551d5827cd1"
  end
  on_arm do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.94/duckdock-linux-arm64.gz"
    sha256 "16f50ae653386c3f8146a1ef79a5d1a3d266b060b176c749535f4d51be6f0cd2"
  end

  # Builds `duckdock host add` copies to remote hosts; it looks in ../lib/duckdock.
  resource "darwin-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.94/duckdock-darwin-arm64"
    sha256 "230e5bba3f6d02e0ba00b4bfb34ac3f79726fe7d9eb70e5e057fc684636d7e1c"
  end

  resource "linux-x64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.94/duckdock-linux-x64.gz"
    sha256 "12e12afceb524d98ef38c593afc355e3be92a4b4cc96c8558e7d0551d5827cd1"
  end

  resource "linux-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.94/duckdock-linux-arm64.gz"
    sha256 "16f50ae653386c3f8146a1ef79a5d1a3d266b060b176c749535f4d51be6f0cd2"
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
