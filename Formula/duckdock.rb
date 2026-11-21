class Duckdock < Formula
  desc "Run Claude Code, Codex and opencode sessions on your SSH hosts from one TUI"
  homepage "https://github.com/askrubberduck/homebrew-tap"
  version "0.5.0"

  # macOS gets the cask, whose app carries this binary. The urls stay outside on_linux: a formula
  # with no url on macOS fails to load, which breaks brew cleanup there.
  depends_on :linux

  on_intel do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.5.0/duckdock-linux-x64.gz"
    sha256 "0322003b4ed8b8dec93deda3e11feb64a46916737cca438674423bc1dd36bf28"
  end
  on_arm do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.5.0/duckdock-linux-arm64.gz"
    sha256 "816a928dec816bee2eba86490aa82911b7bb5a55affee915c8c56be1921428de"
  end

  # Builds `duckdock host add` copies to remote hosts; it looks in ../lib/duckdock.
  resource "darwin-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.5.0/duckdock-darwin-arm64"
    sha256 "b324524aadabed1f9af1f1f5408d570a84304084c200495a2bbb93728fa5b97d"
  end

  resource "linux-x64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.5.0/duckdock-linux-x64.gz"
    sha256 "0322003b4ed8b8dec93deda3e11feb64a46916737cca438674423bc1dd36bf28"
  end

  resource "linux-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.5.0/duckdock-linux-arm64.gz"
    sha256 "816a928dec816bee2eba86490aa82911b7bb5a55affee915c8c56be1921428de"
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
