class Duckdock < Formula
  desc "Run Claude Code, Codex and opencode sessions on your SSH hosts from one TUI"
  homepage "https://github.com/askrubberduck/homebrew-tap"
  version "0.2.40"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.40/duckdock-darwin-arm64"
      sha256 "7c9566689722364acd7f0a277311d4f1b9bf463b9d36100824f1b94b1e09dce0"
    end
    # The arm64 url on Intel too: with none, brew fails with "requires at least a URL", not the
    # arch requirement.
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.40/duckdock-darwin-arm64"
      sha256 "7c9566689722364acd7f0a277311d4f1b9bf463b9d36100824f1b94b1e09dce0"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.40/duckdock-linux-x64.gz"
      sha256 "eef995b8c9cb2ab5b28313245cddfdb759539f35ab0d347a598b31d6b1f67812"
    end
    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.40/duckdock-linux-arm64.gz"
      sha256 "a8a65a97a661cdf5bd6d003b4fb2deb8711576f79a54702270522f900ce5a01e"
    end
  end

  # Linux builds `duckdock host add` copies to remote hosts; it looks in ../lib/duckdock.
  resource "linux-x64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.40/duckdock-linux-x64.gz"
    sha256 "eef995b8c9cb2ab5b28313245cddfdb759539f35ab0d347a598b31d6b1f67812"
  end

  resource "linux-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.40/duckdock-linux-arm64.gz"
    sha256 "a8a65a97a661cdf5bd6d003b4fb2deb8711576f79a54702270522f900ce5a01e"
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
