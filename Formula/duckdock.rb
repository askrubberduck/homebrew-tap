class Duckdock < Formula
  desc "Run Claude Code, Codex and opencode sessions on your SSH hosts from one TUI"
  homepage "https://github.com/askrubberduck/homebrew-tap"
  version "0.2.104"

  # macOS gets the cask, whose app carries this binary. The urls stay outside on_linux: a formula
  # with no url on macOS fails to load, which breaks brew cleanup there.
  depends_on :linux

  on_intel do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.104/duckdock-linux-x64.gz"
    sha256 "2ddc656d36e1eedcd6257a57f6f181e4ab307a2243d43a3abc819ced07d5bab4"
  end
  on_arm do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.104/duckdock-linux-arm64.gz"
    sha256 "33c1388d5f7a857e8a50edefdf145570fbb3a6ed117b914d5463ec909a462544"
  end

  # Builds `duckdock host add` copies to remote hosts; it looks in ../lib/duckdock.
  resource "darwin-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.104/duckdock-darwin-arm64"
    sha256 "ce17c79e1c3df47257c9452979b541cbfd053cfd66f60de9b5de19b4a288cdbd"
  end

  resource "linux-x64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.104/duckdock-linux-x64.gz"
    sha256 "2ddc656d36e1eedcd6257a57f6f181e4ab307a2243d43a3abc819ced07d5bab4"
  end

  resource "linux-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.104/duckdock-linux-arm64.gz"
    sha256 "33c1388d5f7a857e8a50edefdf145570fbb3a6ed117b914d5463ec909a462544"
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
