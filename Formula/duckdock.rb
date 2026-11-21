class Duckdock < Formula
  desc "Run Claude Code, Codex and opencode sessions on your SSH hosts from one TUI"
  homepage "https://github.com/askrubberduck/homebrew-tap"
  version "0.5.3"

  # macOS gets the cask, whose app carries this binary. The urls stay outside on_linux: a formula
  # with no url on macOS fails to load, which breaks brew cleanup there.
  depends_on :linux

  on_intel do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.5.3/duckdock-linux-x64.gz"
    sha256 "ce62818a9e4f6bd820a6c0e5bbe80a32b1e56484db197514317a651dc5640b57"
  end
  on_arm do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.5.3/duckdock-linux-arm64.gz"
    sha256 "daeae9cc7266de5a96a0d7d14cb8f0b3f7cf761a89b9536b8692a0c2cb6a92c3"
  end

  # Builds `duckdock host add` copies to remote hosts; it looks in ../lib/duckdock.
  resource "darwin-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.5.3/duckdock-darwin-arm64"
    sha256 "e80c594af0c3949d4c72061a79f602b64ffbce85c97abc75e05b6bcaec67f409"
  end

  resource "linux-x64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.5.3/duckdock-linux-x64.gz"
    sha256 "ce62818a9e4f6bd820a6c0e5bbe80a32b1e56484db197514317a651dc5640b57"
  end

  resource "linux-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.5.3/duckdock-linux-arm64.gz"
    sha256 "daeae9cc7266de5a96a0d7d14cb8f0b3f7cf761a89b9536b8692a0c2cb6a92c3"
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
