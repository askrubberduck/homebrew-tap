class Duckdock < Formula
  desc "Run Claude Code, Codex and opencode sessions on your SSH hosts from one TUI"
  homepage "https://github.com/askrubberduck/homebrew-tap"
  version "0.2.78"

  # macOS gets the cask, whose app carries this binary.
  depends_on :linux

  on_linux do
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.78/duckdock-linux-x64.gz"
      sha256 "79eeb2d7130a7f1c42340931731ac17a1b04d585f202b6d43f75822c997d4cf4"
    end
    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.78/duckdock-linux-arm64.gz"
      sha256 "8d8f8871035f26dd79970562d02512cdc29359a71e042bc244edccab94d2fee2"
    end
  end

  # Builds `duckdock host add` copies to remote hosts; it looks in ../lib/duckdock.
  resource "darwin-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.78/duckdock-darwin-arm64"
    sha256 "f32afa3c8755100bdf0a1a77f1f304806d454a0d1d9431cb0456034886df87ac"
  end

  resource "linux-x64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.78/duckdock-linux-x64.gz"
    sha256 "79eeb2d7130a7f1c42340931731ac17a1b04d585f202b6d43f75822c997d4cf4"
  end

  resource "linux-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.78/duckdock-linux-arm64.gz"
    sha256 "8d8f8871035f26dd79970562d02512cdc29359a71e042bc244edccab94d2fee2"
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
