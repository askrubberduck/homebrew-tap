class Duckdock < Formula
  desc "Run Claude Code, Codex and opencode sessions on your SSH hosts from one TUI"
  homepage "https://github.com/askrubberduck/homebrew-tap"
  version "0.2.100"

  # macOS gets the cask, whose app carries this binary. The urls stay outside on_linux: a formula
  # with no url on macOS fails to load, which breaks brew cleanup there.
  depends_on :linux

  on_intel do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.100/duckdock-linux-x64.gz"
    sha256 "4cb5fd197a77a6dd74892552f38d48308c2d1afab7e7a7807ce9a98fa74559e2"
  end
  on_arm do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.100/duckdock-linux-arm64.gz"
    sha256 "da92e55c284def195386f502a1f29e4f07cf86746c4790bf5bdf3e4784c1c124"
  end

  # Builds `duckdock host add` copies to remote hosts; it looks in ../lib/duckdock.
  resource "darwin-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.100/duckdock-darwin-arm64"
    sha256 "adfaaaced0ccc63a35045e8e7df3253ebca1f534870e4a356d5758852447e216"
  end

  resource "linux-x64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.100/duckdock-linux-x64.gz"
    sha256 "4cb5fd197a77a6dd74892552f38d48308c2d1afab7e7a7807ce9a98fa74559e2"
  end

  resource "linux-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.100/duckdock-linux-arm64.gz"
    sha256 "da92e55c284def195386f502a1f29e4f07cf86746c4790bf5bdf3e4784c1c124"
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
