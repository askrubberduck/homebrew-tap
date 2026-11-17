class Duckdock < Formula
  desc "Run Claude Code, Codex and opencode sessions on your SSH hosts from one TUI"
  homepage "https://github.com/askrubberduck/homebrew-tap"
  version "0.2.114"

  # macOS gets the cask, whose app carries this binary. The urls stay outside on_linux: a formula
  # with no url on macOS fails to load, which breaks brew cleanup there.
  depends_on :linux

  on_intel do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.114/duckdock-linux-x64.gz"
    sha256 "a700390e656a29a31899295b12681e05ce11744f58528f29fc12bdb7d571aa40"
  end
  on_arm do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.114/duckdock-linux-arm64.gz"
    sha256 "a8cbbd586c85f4da4c3afb8bf20fad9c2f13ebff376aa19d62ec6322a789695d"
  end

  # Builds `duckdock host add` copies to remote hosts; it looks in ../lib/duckdock.
  resource "darwin-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.114/duckdock-darwin-arm64"
    sha256 "d7ea5efebfea9597f687d80cccbccc76f3006f0789d283e06ec7b8c478da2189"
  end

  resource "linux-x64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.114/duckdock-linux-x64.gz"
    sha256 "a700390e656a29a31899295b12681e05ce11744f58528f29fc12bdb7d571aa40"
  end

  resource "linux-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.114/duckdock-linux-arm64.gz"
    sha256 "a8cbbd586c85f4da4c3afb8bf20fad9c2f13ebff376aa19d62ec6322a789695d"
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
