class Duckdock < Formula
  desc "Run Claude Code, Codex and opencode sessions on your SSH hosts from one TUI"
  homepage "https://github.com/askrubberduck/homebrew-tap"
  version "0.2.65"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.65/duckdock-darwin-arm64"
      sha256 "9cf442d0b6dc10c06db5e474f0ca591207124562d28c8b5342ce3a299147ec25"
    end
    # The arm64 url on Intel too: with none, brew fails with "requires at least a URL", not the
    # arch requirement.
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.65/duckdock-darwin-arm64"
      sha256 "9cf442d0b6dc10c06db5e474f0ca591207124562d28c8b5342ce3a299147ec25"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.65/duckdock-linux-x64.gz"
      sha256 "340670fb8e3ac3ca77cfcc4ab376653be97160c5e1e13e1995b55ced523074de"
    end
    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.65/duckdock-linux-arm64.gz"
      sha256 "7c431ec34b742a2f8eca1bdead40aae7f6d8551adec7f041831712773f982ac2"
    end
  end

  # Linux builds `duckdock host add` copies to remote hosts; it looks in ../lib/duckdock.
  resource "linux-x64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.65/duckdock-linux-x64.gz"
    sha256 "340670fb8e3ac3ca77cfcc4ab376653be97160c5e1e13e1995b55ced523074de"
  end

  resource "linux-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.65/duckdock-linux-arm64.gz"
    sha256 "7c431ec34b742a2f8eca1bdead40aae7f6d8551adec7f041831712773f982ac2"
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
