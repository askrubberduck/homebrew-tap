class Duckdock < Formula
  desc "Run Claude Code, Codex and opencode sessions on your SSH hosts from one TUI"
  homepage "https://github.com/askrubberduck/homebrew-tap"
  version "0.5.5"

  # macOS gets the cask, whose app carries this binary. The urls stay outside on_linux: a formula
  # with no url on macOS fails to load, which breaks brew cleanup there.
  depends_on :linux

  on_intel do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.5.5/duckdock-linux-x64.gz"
    sha256 "6c0a2377d50477bf579c3ff7974eddfcaf2baec3190029a5e2eaa0f4e78510e8"
  end
  on_arm do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.5.5/duckdock-linux-arm64.gz"
    sha256 "391038ece8bddd7d17708231e90ef53be9bbaba5d27e8c805fe35f23ddb65109"
  end

  # Builds `duckdock host add` copies to remote hosts; it looks in ../lib/duckdock.
  resource "darwin-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.5.5/duckdock-darwin-arm64"
    sha256 "f10008769aeb6be1019eab2c9517ed5c09adf30aecb79042deee390a452375f3"
  end

  resource "linux-x64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.5.5/duckdock-linux-x64.gz"
    sha256 "6c0a2377d50477bf579c3ff7974eddfcaf2baec3190029a5e2eaa0f4e78510e8"
  end

  resource "linux-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.5.5/duckdock-linux-arm64.gz"
    sha256 "391038ece8bddd7d17708231e90ef53be9bbaba5d27e8c805fe35f23ddb65109"
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
