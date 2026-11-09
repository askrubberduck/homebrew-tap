class Duckdock < Formula
  desc "Run Claude Code, Codex and opencode sessions on your SSH hosts from one TUI"
  homepage "https://github.com/askrubberduck/homebrew-tap"
  version "0.2.97"

  # macOS gets the cask, whose app carries this binary. The urls stay outside on_linux: a formula
  # with no url on macOS fails to load, which breaks brew cleanup there.
  depends_on :linux

  on_intel do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.97/duckdock-linux-x64.gz"
    sha256 "bcdaeab96d4f45e4506e81a906513bd1ec694ac3c353c213d5a71bb4d4065e9f"
  end
  on_arm do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.97/duckdock-linux-arm64.gz"
    sha256 "b82c2aa83e7b1c7bae81729636de2a548411dc1a37bb94ef4ad88bfe02f58a59"
  end

  # Builds `duckdock host add` copies to remote hosts; it looks in ../lib/duckdock.
  resource "darwin-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.97/duckdock-darwin-arm64"
    sha256 "d8bd53d9d5e94c4d9133368a70aaf70bef0addfa24ea36902ef1b33be3c36416"
  end

  resource "linux-x64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.97/duckdock-linux-x64.gz"
    sha256 "bcdaeab96d4f45e4506e81a906513bd1ec694ac3c353c213d5a71bb4d4065e9f"
  end

  resource "linux-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.97/duckdock-linux-arm64.gz"
    sha256 "b82c2aa83e7b1c7bae81729636de2a548411dc1a37bb94ef4ad88bfe02f58a59"
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
