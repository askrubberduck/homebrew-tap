class Duckdock < Formula
  desc "Run Claude Code, Codex and opencode sessions on your SSH hosts from one TUI"
  homepage "https://github.com/askrubberduck/homebrew-tap"
  version "0.2.73"

  # macOS gets the cask, whose app carries this binary.
  depends_on :linux

  on_linux do
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.73/duckdock-linux-x64.gz"
      sha256 "6d994c7c9e785fb26d4d86a5de0a9debf223e492c2f261e7942124a372da768c"
    end
    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.73/duckdock-linux-arm64.gz"
      sha256 "a142f7c778cd4cd820ad44803a32181f7790740445e8e9e63f7858e1720561ed"
    end
  end

  # Builds `duckdock host add` copies to remote hosts; it looks in ../lib/duckdock.
  resource "darwin-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.73/duckdock-darwin-arm64"
    sha256 "72a8d7cee01ffaded74435e16dd54ab9ef6fcdb8fde17222ade666796cbb1c01"
  end

  resource "linux-x64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.73/duckdock-linux-x64.gz"
    sha256 "6d994c7c9e785fb26d4d86a5de0a9debf223e492c2f261e7942124a372da768c"
  end

  resource "linux-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.73/duckdock-linux-arm64.gz"
    sha256 "a142f7c778cd4cd820ad44803a32181f7790740445e8e9e63f7858e1720561ed"
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
