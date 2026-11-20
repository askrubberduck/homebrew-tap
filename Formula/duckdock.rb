class Duckdock < Formula
  desc "Run Claude Code, Codex and opencode sessions on your SSH hosts from one TUI"
  homepage "https://github.com/askrubberduck/homebrew-tap"
  version "0.3.0"

  # macOS gets the cask, whose app carries this binary. The urls stay outside on_linux: a formula
  # with no url on macOS fails to load, which breaks brew cleanup there.
  depends_on :linux

  on_intel do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.3.0/duckdock-linux-x64.gz"
    sha256 "8e7ccd8865dc517df236d33dd7e740687482fdcbf4420e8c0e23fd590b117241"
  end
  on_arm do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.3.0/duckdock-linux-arm64.gz"
    sha256 "c4f1f07b16c7f0ecec02e15658fcb48db772d2eff365291cd1c662c41b73cbe4"
  end

  # Builds `duckdock host add` copies to remote hosts; it looks in ../lib/duckdock.
  resource "darwin-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.3.0/duckdock-darwin-arm64"
    sha256 "0b5d9e4862d37d8a703f952d4dd4bc860c6f892130f52e728630b55e08e41145"
  end

  resource "linux-x64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.3.0/duckdock-linux-x64.gz"
    sha256 "8e7ccd8865dc517df236d33dd7e740687482fdcbf4420e8c0e23fd590b117241"
  end

  resource "linux-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.3.0/duckdock-linux-arm64.gz"
    sha256 "c4f1f07b16c7f0ecec02e15658fcb48db772d2eff365291cd1c662c41b73cbe4"
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
