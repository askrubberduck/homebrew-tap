class Duckdock < Formula
  desc "Run Claude Code, Codex and opencode sessions on your SSH hosts from one TUI"
  homepage "https://github.com/askrubberduck/homebrew-tap"
  version "0.2.56"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.56/duckdock-darwin-arm64"
      sha256 "b5d04fd267bc1070b9426b982e09475f58b17de4728b6a22d8eeb215505121ed"
    end
    # The arm64 url on Intel too: with none, brew fails with "requires at least a URL", not the
    # arch requirement.
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.56/duckdock-darwin-arm64"
      sha256 "b5d04fd267bc1070b9426b982e09475f58b17de4728b6a22d8eeb215505121ed"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.56/duckdock-linux-x64.gz"
      sha256 "244489de87102d3392a0c7c8cb75f82a773c24c4a267a8c12d7d47f0a4cc8ae9"
    end
    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.56/duckdock-linux-arm64.gz"
      sha256 "9c82f487d7d8208d6f1448347e54d72da060cec15dcc3d58ed632be2ee1dc416"
    end
  end

  # Linux builds `duckdock host add` copies to remote hosts; it looks in ../lib/duckdock.
  resource "linux-x64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.56/duckdock-linux-x64.gz"
    sha256 "244489de87102d3392a0c7c8cb75f82a773c24c4a267a8c12d7d47f0a4cc8ae9"
  end

  resource "linux-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.56/duckdock-linux-arm64.gz"
    sha256 "9c82f487d7d8208d6f1448347e54d72da060cec15dcc3d58ed632be2ee1dc416"
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
