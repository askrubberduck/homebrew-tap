class Duckdock < Formula
  desc "Run Claude Code, Codex and opencode sessions on your SSH hosts from one TUI"
  homepage "https://github.com/askrubberduck/homebrew-tap"
  version "0.2.67"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.67/duckdock-darwin-arm64"
      sha256 "5706f1d6cdcb7ec4a865a7594bada4f84b97fc77dc8775b82eea5890d0eed609"
    end
    # The arm64 url on Intel too: with none, brew fails with "requires at least a URL", not the
    # arch requirement.
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.67/duckdock-darwin-arm64"
      sha256 "5706f1d6cdcb7ec4a865a7594bada4f84b97fc77dc8775b82eea5890d0eed609"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.67/duckdock-linux-x64.gz"
      sha256 "401d7879b2014f789036af646c56a6476ea914aeb27058d4f34ef6fe262c03f6"
    end
    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.67/duckdock-linux-arm64.gz"
      sha256 "045b8871e03a937d3407d70e5092d74be7f9fb6c1a03ac04d171f9d62cdd5201"
    end
  end

  # Linux builds `duckdock host add` copies to remote hosts; it looks in ../lib/duckdock.
  resource "linux-x64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.67/duckdock-linux-x64.gz"
    sha256 "401d7879b2014f789036af646c56a6476ea914aeb27058d4f34ef6fe262c03f6"
  end

  resource "linux-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.67/duckdock-linux-arm64.gz"
    sha256 "045b8871e03a937d3407d70e5092d74be7f9fb6c1a03ac04d171f9d62cdd5201"
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
