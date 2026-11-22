class Duckdock < Formula
  desc "Run Claude Code, Codex and opencode sessions on your SSH hosts from one TUI"
  homepage "https://github.com/askrubberduck/homebrew-tap"
  version "0.5.4"

  # macOS gets the cask, whose app carries this binary. The urls stay outside on_linux: a formula
  # with no url on macOS fails to load, which breaks brew cleanup there.
  depends_on :linux

  on_intel do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.5.4/duckdock-linux-x64.gz"
    sha256 "7e19f468b620ef712c44e28bb750d85f6a1d5c57e99b6c5340e3e0ebc9b10803"
  end
  on_arm do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.5.4/duckdock-linux-arm64.gz"
    sha256 "c4b30c51010b13857a8456b1678b8a49d7a3c57f7797c74710fdff5359d03acd"
  end

  # Builds `duckdock host add` copies to remote hosts; it looks in ../lib/duckdock.
  resource "darwin-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.5.4/duckdock-darwin-arm64"
    sha256 "2ad9b8ca39eaa078b946256a1ede534375d72903308a272b0b2ac823f45926f8"
  end

  resource "linux-x64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.5.4/duckdock-linux-x64.gz"
    sha256 "7e19f468b620ef712c44e28bb750d85f6a1d5c57e99b6c5340e3e0ebc9b10803"
  end

  resource "linux-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.5.4/duckdock-linux-arm64.gz"
    sha256 "c4b30c51010b13857a8456b1678b8a49d7a3c57f7797c74710fdff5359d03acd"
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
