class Duckdock < Formula
  desc "Run Claude Code, Codex and opencode sessions on your SSH hosts from one TUI"
  homepage "https://github.com/askrubberduck/homebrew-tap"
  version "0.2.32"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.32/duckdock-darwin-arm64"
      sha256 "001497e64cda12de40ef53f7cf94e797c6d5de4f5405f0c6b13a257b8df2e359"
    end
    # The arm64 url on Intel too: with none, brew fails with "requires at least a URL", not the
    # arch requirement.
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.32/duckdock-darwin-arm64"
      sha256 "001497e64cda12de40ef53f7cf94e797c6d5de4f5405f0c6b13a257b8df2e359"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.32/duckdock-linux-x64.gz"
      sha256 "546327be6867fd761f97603c544895969202ae2d7dd7287b9fd3c9ed1bc71f45"
    end
    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.32/duckdock-linux-arm64.gz"
      sha256 "0a45fd2a942753a8af87afbeeeb533de9e271046157331565459f7699ffc1d67"
    end
  end

  # Linux builds `duckdock host add` copies to remote hosts; it looks in ../lib/duckdock.
  resource "linux-x64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.32/duckdock-linux-x64.gz"
    sha256 "546327be6867fd761f97603c544895969202ae2d7dd7287b9fd3c9ed1bc71f45"
  end

  resource "linux-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.32/duckdock-linux-arm64.gz"
    sha256 "0a45fd2a942753a8af87afbeeeb533de9e271046157331565459f7699ffc1d67"
  end

  def install
    # Raw download keeps its name; Homebrew gunzips the .gz ones to duckdock-linux-<arch>.
    bin.install Dir["duckdock-*"].first => "duckdock"
    chmod 0755, bin/"duckdock" # downloads and gunzip carry no exec bit
    %w[linux-x64 linux-arm64].each do |t|
      resource(t).stage { (lib/"duckdock").install Dir["duckdock-*"].first => "duckdock-#{t}" }
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/duckdock --version")
  end
end
