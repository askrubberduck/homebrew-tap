class Duckdock < Formula
  desc "Run Claude Code, Codex and opencode sessions on your SSH hosts from one TUI"
  homepage "https://github.com/askrubberduck/homebrew-tap"
  version "0.2.89"

  # macOS gets the cask, whose app carries this binary. The urls stay outside on_linux: a formula
  # with no url on macOS fails to load, which breaks brew cleanup there.
  depends_on :linux

  on_intel do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.89/duckdock-linux-x64.gz"
    sha256 "fe86b735cbdfc15df6ad22b00cfd369c0fa7a4b294e995a0dbf27cbf7e0f760c"
  end
  on_arm do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.89/duckdock-linux-arm64.gz"
    sha256 "a4ab88f34024e64435208b3544f2e33535afc1b19b8d92ab0b21f86c0b29a950"
  end

  # Builds `duckdock host add` copies to remote hosts; it looks in ../lib/duckdock.
  resource "darwin-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.89/duckdock-darwin-arm64"
    sha256 "0423a0efd2aca6ec55c0e3ae0b0188c0aa332a3b0fc4a2f12caa7d8923f5d4a6"
  end

  resource "linux-x64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.89/duckdock-linux-x64.gz"
    sha256 "fe86b735cbdfc15df6ad22b00cfd369c0fa7a4b294e995a0dbf27cbf7e0f760c"
  end

  resource "linux-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.89/duckdock-linux-arm64.gz"
    sha256 "a4ab88f34024e64435208b3544f2e33535afc1b19b8d92ab0b21f86c0b29a950"
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
