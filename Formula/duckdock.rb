class Duckdock < Formula
  desc "Run Claude Code, Codex and opencode sessions on your SSH hosts from one TUI"
  homepage "https://github.com/askrubberduck/homebrew-tap"
  version "0.2.49"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.49/duckdock-darwin-arm64"
      sha256 "b866f6c0b4e4490b06828d1ca1093cb7bc6043b10b1e5ad405927a6051ef28f1"
    end
    # The arm64 url on Intel too: with none, brew fails with "requires at least a URL", not the
    # arch requirement.
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.49/duckdock-darwin-arm64"
      sha256 "b866f6c0b4e4490b06828d1ca1093cb7bc6043b10b1e5ad405927a6051ef28f1"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.49/duckdock-linux-x64.gz"
      sha256 "c7f4b6fe666144d8d10f22dde6429817225b6defa5c50ab21e38ca015474801b"
    end
    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.49/duckdock-linux-arm64.gz"
      sha256 "6a8a09c2fbf1ae81ffd09bc515978d5fe3ac8d4c86e1d2229851d43cca99538e"
    end
  end

  # Linux builds `duckdock host add` copies to remote hosts; it looks in ../lib/duckdock.
  resource "linux-x64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.49/duckdock-linux-x64.gz"
    sha256 "c7f4b6fe666144d8d10f22dde6429817225b6defa5c50ab21e38ca015474801b"
  end

  resource "linux-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.49/duckdock-linux-arm64.gz"
    sha256 "6a8a09c2fbf1ae81ffd09bc515978d5fe3ac8d4c86e1d2229851d43cca99538e"
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
