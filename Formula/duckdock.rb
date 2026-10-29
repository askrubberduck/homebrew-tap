class Duckdock < Formula
  desc "Run Claude Code, Codex and opencode sessions on your SSH hosts from one TUI"
  homepage "https://github.com/askrubberduck/homebrew-tap"
  version "0.2.59"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.59/duckdock-darwin-arm64"
      sha256 "eed00149f64a9b541954b6a56a03f90e8b3eb1fe998535874577775b3aacfe9a"
    end
    # The arm64 url on Intel too: with none, brew fails with "requires at least a URL", not the
    # arch requirement.
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.59/duckdock-darwin-arm64"
      sha256 "eed00149f64a9b541954b6a56a03f90e8b3eb1fe998535874577775b3aacfe9a"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.59/duckdock-linux-x64.gz"
      sha256 "4ecab27c83b159be93d195c166c930d700691a50aeb7c8c4f4412f1b7d423ea1"
    end
    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.59/duckdock-linux-arm64.gz"
      sha256 "35af6f214ddd663183ed8c547daca38f999738f330d9d520ea48c87042501cb5"
    end
  end

  # Linux builds `duckdock host add` copies to remote hosts; it looks in ../lib/duckdock.
  resource "linux-x64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.59/duckdock-linux-x64.gz"
    sha256 "4ecab27c83b159be93d195c166c930d700691a50aeb7c8c4f4412f1b7d423ea1"
  end

  resource "linux-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.59/duckdock-linux-arm64.gz"
    sha256 "35af6f214ddd663183ed8c547daca38f999738f330d9d520ea48c87042501cb5"
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
