class Duckdock < Formula
  desc "Run Claude Code, Codex and opencode sessions on your SSH hosts from one TUI"
  homepage "https://github.com/askrubberduck/homebrew-tap"
  version "0.2.82"

  # macOS gets the cask, whose app carries this binary. The urls stay outside on_linux: a formula
  # with no url on macOS fails to load, which breaks brew cleanup there.
  depends_on :linux

  on_intel do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.82/duckdock-linux-x64.gz"
    sha256 "81674f80520b80dacee5196aae2d938b40d5fc4888086562ff9b58d2844308e9"
  end
  on_arm do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.82/duckdock-linux-arm64.gz"
    sha256 "eaf961cf7a29902a50428a1c1a53499d17a032900498d13de9b4dee79135e3c0"
  end

  # Builds `duckdock host add` copies to remote hosts; it looks in ../lib/duckdock.
  resource "darwin-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.82/duckdock-darwin-arm64"
    sha256 "9e2e2193a96db4b469639d21d92f3704db680a76590e5a2171b3eb102154360a"
  end

  resource "linux-x64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.82/duckdock-linux-x64.gz"
    sha256 "81674f80520b80dacee5196aae2d938b40d5fc4888086562ff9b58d2844308e9"
  end

  resource "linux-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.82/duckdock-linux-arm64.gz"
    sha256 "eaf961cf7a29902a50428a1c1a53499d17a032900498d13de9b4dee79135e3c0"
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
