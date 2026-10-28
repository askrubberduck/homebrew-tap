class Duckdock < Formula
  desc "Run Claude Code, Codex and opencode sessions on your SSH hosts from one TUI"
  homepage "https://github.com/askrubberduck/homebrew-tap"
  version "0.2.51"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.51/duckdock-darwin-arm64"
      sha256 "716ca4ea4bae14a888881b3783c92d41651796d2377367182a6692ce5fd1e967"
    end
    # The arm64 url on Intel too: with none, brew fails with "requires at least a URL", not the
    # arch requirement.
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.51/duckdock-darwin-arm64"
      sha256 "716ca4ea4bae14a888881b3783c92d41651796d2377367182a6692ce5fd1e967"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.51/duckdock-linux-x64.gz"
      sha256 "4f95426fa9d895726db0f52a0f31d6cbbb23086ae7554955c5717f28ca3c69df"
    end
    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.51/duckdock-linux-arm64.gz"
      sha256 "7f9ebf05db7ccf27d1b78d6e387335ca00c4d87193bee469a67c298c9a7f96dd"
    end
  end

  # Linux builds `duckdock host add` copies to remote hosts; it looks in ../lib/duckdock.
  resource "linux-x64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.51/duckdock-linux-x64.gz"
    sha256 "4f95426fa9d895726db0f52a0f31d6cbbb23086ae7554955c5717f28ca3c69df"
  end

  resource "linux-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.51/duckdock-linux-arm64.gz"
    sha256 "7f9ebf05db7ccf27d1b78d6e387335ca00c4d87193bee469a67c298c9a7f96dd"
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
