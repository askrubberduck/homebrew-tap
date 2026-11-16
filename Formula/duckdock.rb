class Duckdock < Formula
  desc "Run Claude Code, Codex and opencode sessions on your SSH hosts from one TUI"
  homepage "https://github.com/askrubberduck/homebrew-tap"
  version "0.2.113"

  # macOS gets the cask, whose app carries this binary. The urls stay outside on_linux: a formula
  # with no url on macOS fails to load, which breaks brew cleanup there.
  depends_on :linux

  on_intel do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.113/duckdock-linux-x64.gz"
    sha256 "99b12f9af420671e4686d9a09c79208b5c8e896e5003c3a608bf9a2df7f341d3"
  end
  on_arm do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.113/duckdock-linux-arm64.gz"
    sha256 "1ed7ede44866167edce2e164d46409a97c563cb9142a735e13d7725ee88f58e3"
  end

  # Builds `duckdock host add` copies to remote hosts; it looks in ../lib/duckdock.
  resource "darwin-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.113/duckdock-darwin-arm64"
    sha256 "06a4c55dab1e401a75cc8119a5891fdc65eb2923c80f7ddc550bce81b6194e51"
  end

  resource "linux-x64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.113/duckdock-linux-x64.gz"
    sha256 "99b12f9af420671e4686d9a09c79208b5c8e896e5003c3a608bf9a2df7f341d3"
  end

  resource "linux-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.113/duckdock-linux-arm64.gz"
    sha256 "1ed7ede44866167edce2e164d46409a97c563cb9142a735e13d7725ee88f58e3"
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
