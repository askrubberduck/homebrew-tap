class Duckdock < Formula
  desc "Run Claude Code, Codex and opencode sessions on your SSH hosts from one TUI"
  homepage "https://github.com/askrubberduck/homebrew-tap"
  version "0.2.86"

  # macOS gets the cask, whose app carries this binary. The urls stay outside on_linux: a formula
  # with no url on macOS fails to load, which breaks brew cleanup there.
  depends_on :linux

  on_intel do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.86/duckdock-linux-x64.gz"
    sha256 "3630a780299f341136cac91993af9e7b8d122e70599bc55789651b327ef00508"
  end
  on_arm do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.86/duckdock-linux-arm64.gz"
    sha256 "42fbbe48f760023f62c1caad6c45d8e0412a5a341ad0f42123908579b1c31aad"
  end

  # Builds `duckdock host add` copies to remote hosts; it looks in ../lib/duckdock.
  resource "darwin-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.86/duckdock-darwin-arm64"
    sha256 "c27b3a12fd05b8fa857655da49be2044b5b909df8af3f157db5a2db6f1d2d75d"
  end

  resource "linux-x64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.86/duckdock-linux-x64.gz"
    sha256 "3630a780299f341136cac91993af9e7b8d122e70599bc55789651b327ef00508"
  end

  resource "linux-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.86/duckdock-linux-arm64.gz"
    sha256 "42fbbe48f760023f62c1caad6c45d8e0412a5a341ad0f42123908579b1c31aad"
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
