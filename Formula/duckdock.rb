class Duckdock < Formula
  desc "Run Claude Code, Codex and opencode sessions on your SSH hosts from one TUI"
  homepage "https://github.com/askrubberduck/homebrew-tap"
  version "0.2.55"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.55/duckdock-darwin-arm64"
      sha256 "fbcc205f7e86474ada972ef7776f100a16ab7ced364e76158c1d09881bd8d0cb"
    end
    # The arm64 url on Intel too: with none, brew fails with "requires at least a URL", not the
    # arch requirement.
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.55/duckdock-darwin-arm64"
      sha256 "fbcc205f7e86474ada972ef7776f100a16ab7ced364e76158c1d09881bd8d0cb"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.55/duckdock-linux-x64.gz"
      sha256 "876cfad9bfad80e35d5d1eaeb413fbc93cd63b42d2c9dd076783247309920915"
    end
    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.55/duckdock-linux-arm64.gz"
      sha256 "f33253fafe41aed763b28671bae916ef1b4bb4c38e4eade0fd75d5e213b76b3e"
    end
  end

  # Linux builds `duckdock host add` copies to remote hosts; it looks in ../lib/duckdock.
  resource "linux-x64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.55/duckdock-linux-x64.gz"
    sha256 "876cfad9bfad80e35d5d1eaeb413fbc93cd63b42d2c9dd076783247309920915"
  end

  resource "linux-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.55/duckdock-linux-arm64.gz"
    sha256 "f33253fafe41aed763b28671bae916ef1b4bb4c38e4eade0fd75d5e213b76b3e"
  end

  def install
    # Raw download keeps its name; Homebrew gunzips the .gz ones to duckdock-linux-<arch>.
    bin.install Dir["duckdock-*"].first => "duckdock"
    chmod 0755, bin/"duckdock" # downloads and gunzip carry no exec bit
    %w[linux-x64 linux-arm64].each do |t|
      resource(t).stage { (lib/"duckdock").install Dir["duckdock-*"].first => "duckdock-#{t}" }
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/duckdock --version")
  end
end
