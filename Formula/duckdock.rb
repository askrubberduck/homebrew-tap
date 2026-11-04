class Duckdock < Formula
  desc "Run Claude Code, Codex and opencode sessions on your SSH hosts from one TUI"
  homepage "https://github.com/askrubberduck/homebrew-tap"
  version "0.2.87"

  # macOS gets the cask, whose app carries this binary. The urls stay outside on_linux: a formula
  # with no url on macOS fails to load, which breaks brew cleanup there.
  depends_on :linux

  on_intel do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.87/duckdock-linux-x64.gz"
    sha256 "36498fc24ede6dc46a593947e71e8e98eb90421a7353e6895d8ca3960b3127b2"
  end
  on_arm do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.87/duckdock-linux-arm64.gz"
    sha256 "4da77aaf497f170883853efb58aa31095485ec972d007b93532289e76c8c2f5d"
  end

  # Builds `duckdock host add` copies to remote hosts; it looks in ../lib/duckdock.
  resource "darwin-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.87/duckdock-darwin-arm64"
    sha256 "df30689661c09bffaade60224a89948d068083b3a092dc88041c56e9b4cba536"
  end

  resource "linux-x64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.87/duckdock-linux-x64.gz"
    sha256 "36498fc24ede6dc46a593947e71e8e98eb90421a7353e6895d8ca3960b3127b2"
  end

  resource "linux-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.87/duckdock-linux-arm64.gz"
    sha256 "4da77aaf497f170883853efb58aa31095485ec972d007b93532289e76c8c2f5d"
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
