class Duckdock < Formula
  desc "Run Claude Code, Codex and opencode sessions on your SSH hosts from one TUI"
  homepage "https://github.com/askrubberduck/homebrew-tap"
  version "0.2.92"

  # macOS gets the cask, whose app carries this binary. The urls stay outside on_linux: a formula
  # with no url on macOS fails to load, which breaks brew cleanup there.
  depends_on :linux

  on_intel do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.92/duckdock-linux-x64.gz"
    sha256 "f6f07f67e9adab37682015611be75e785f06ba2e8873d8d8033d1586b14ce80d"
  end
  on_arm do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.92/duckdock-linux-arm64.gz"
    sha256 "150bc6cf662a35e61db0bf6ff8c01a90fbaa749b75d2f687d01e3cbffd376af6"
  end

  # Builds `duckdock host add` copies to remote hosts; it looks in ../lib/duckdock.
  resource "darwin-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.92/duckdock-darwin-arm64"
    sha256 "9df65fd33c56c4b53655fa42fcf0c180be599e20761b47c2102e64dfaf0cee30"
  end

  resource "linux-x64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.92/duckdock-linux-x64.gz"
    sha256 "f6f07f67e9adab37682015611be75e785f06ba2e8873d8d8033d1586b14ce80d"
  end

  resource "linux-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.92/duckdock-linux-arm64.gz"
    sha256 "150bc6cf662a35e61db0bf6ff8c01a90fbaa749b75d2f687d01e3cbffd376af6"
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
