class Duckdock < Formula
  desc "Run Claude Code, Codex and opencode sessions on your SSH hosts from one TUI"
  homepage "https://github.com/askrubberduck/homebrew-tap"
  version "0.2.99"

  # macOS gets the cask, whose app carries this binary. The urls stay outside on_linux: a formula
  # with no url on macOS fails to load, which breaks brew cleanup there.
  depends_on :linux

  on_intel do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.99/duckdock-linux-x64.gz"
    sha256 "85348e82b2f88f1913205bad605aeac86313926ee88003b56bc2d3a33386cfa0"
  end
  on_arm do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.99/duckdock-linux-arm64.gz"
    sha256 "7b0d23f1e2982a001228ecc96491dc2f6d303e20318d0f7fa397fd92c3e74899"
  end

  # Builds `duckdock host add` copies to remote hosts; it looks in ../lib/duckdock.
  resource "darwin-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.99/duckdock-darwin-arm64"
    sha256 "e3b1506923610660c9109c2c24d9be967d5fa44e574145aae9fe79277cdb58aa"
  end

  resource "linux-x64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.99/duckdock-linux-x64.gz"
    sha256 "85348e82b2f88f1913205bad605aeac86313926ee88003b56bc2d3a33386cfa0"
  end

  resource "linux-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.99/duckdock-linux-arm64.gz"
    sha256 "7b0d23f1e2982a001228ecc96491dc2f6d303e20318d0f7fa397fd92c3e74899"
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
