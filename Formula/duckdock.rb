class Duckdock < Formula
  desc "Run Claude Code, Codex and opencode sessions on your SSH hosts from one TUI"
  homepage "https://github.com/askrubberduck/homebrew-tap"
  version "0.2.44"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.44/duckdock-darwin-arm64"
      sha256 "c55cba1478da94a925ef472daa4655a4c01b9b82c7276cb5731717d82c35dab2"
    end
    # The arm64 url on Intel too: with none, brew fails with "requires at least a URL", not the
    # arch requirement.
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.44/duckdock-darwin-arm64"
      sha256 "c55cba1478da94a925ef472daa4655a4c01b9b82c7276cb5731717d82c35dab2"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.44/duckdock-linux-x64.gz"
      sha256 "0a1cf25c55cf4934b17cd4e2143c5c50d2b56d18fa437bdd93f2b1d8a9441328"
    end
    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.44/duckdock-linux-arm64.gz"
      sha256 "bf029699345f7322f6c7249993dbaac6071a3c191bb553b5ef00a28e61d0759c"
    end
  end

  # Linux builds `duckdock host add` copies to remote hosts; it looks in ../lib/duckdock.
  resource "linux-x64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.44/duckdock-linux-x64.gz"
    sha256 "0a1cf25c55cf4934b17cd4e2143c5c50d2b56d18fa437bdd93f2b1d8a9441328"
  end

  resource "linux-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.44/duckdock-linux-arm64.gz"
    sha256 "bf029699345f7322f6c7249993dbaac6071a3c191bb553b5ef00a28e61d0759c"
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
