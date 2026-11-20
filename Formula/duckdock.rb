class Duckdock < Formula
  desc "Run Claude Code, Codex and opencode sessions on your SSH hosts from one TUI"
  homepage "https://github.com/askrubberduck/homebrew-tap"
  version "0.2.119"

  # macOS gets the cask, whose app carries this binary. The urls stay outside on_linux: a formula
  # with no url on macOS fails to load, which breaks brew cleanup there.
  depends_on :linux

  on_intel do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.119/duckdock-linux-x64.gz"
    sha256 "a9b93774f34484a99549152d2cb6253f4ffdcd3d4d6b081cce2ef1975cc18443"
  end
  on_arm do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.119/duckdock-linux-arm64.gz"
    sha256 "6d81d391ca3cb4efe316c60935af07ec24dfe5b1701d99ea9afa600472919108"
  end

  # Builds `duckdock host add` copies to remote hosts; it looks in ../lib/duckdock.
  resource "darwin-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.119/duckdock-darwin-arm64"
    sha256 "6a6203a8a580ffeb1141bcf4a4ba3e130693a2a601cb493da33f2714dbfd4233"
  end

  resource "linux-x64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.119/duckdock-linux-x64.gz"
    sha256 "a9b93774f34484a99549152d2cb6253f4ffdcd3d4d6b081cce2ef1975cc18443"
  end

  resource "linux-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.119/duckdock-linux-arm64.gz"
    sha256 "6d81d391ca3cb4efe316c60935af07ec24dfe5b1701d99ea9afa600472919108"
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
