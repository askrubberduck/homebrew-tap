class Duckdock < Formula
  desc "Run Claude Code, Codex and opencode sessions on your SSH hosts from one TUI"
  homepage "https://github.com/askrubberduck/homebrew-tap"
  version "0.2.115"

  # macOS gets the cask, whose app carries this binary. The urls stay outside on_linux: a formula
  # with no url on macOS fails to load, which breaks brew cleanup there.
  depends_on :linux

  on_intel do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.115/duckdock-linux-x64.gz"
    sha256 "29983d9a02b5b1afcaa4ec5d4c7c713ee31da69aaea65fd4da435ef9b795e96e"
  end
  on_arm do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.115/duckdock-linux-arm64.gz"
    sha256 "40a8d05d66d7b9872b5825cf7bfca82accba4450d13a279c9f5628653906eb43"
  end

  # Builds `duckdock host add` copies to remote hosts; it looks in ../lib/duckdock.
  resource "darwin-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.115/duckdock-darwin-arm64"
    sha256 "6f8507bfc31efcbb9808674d8e5fea67ef769b16a21ad73d3b735d89de17a427"
  end

  resource "linux-x64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.115/duckdock-linux-x64.gz"
    sha256 "29983d9a02b5b1afcaa4ec5d4c7c713ee31da69aaea65fd4da435ef9b795e96e"
  end

  resource "linux-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.115/duckdock-linux-arm64.gz"
    sha256 "40a8d05d66d7b9872b5825cf7bfca82accba4450d13a279c9f5628653906eb43"
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
