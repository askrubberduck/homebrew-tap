class Duckdock < Formula
  desc "Run Claude Code, Codex and opencode sessions on your SSH hosts from one TUI"
  homepage "https://github.com/askrubberduck/homebrew-tap"
  version "0.2.23"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.23/duckdock-darwin-arm64"
      sha256 "58673f1808a6076cc0ddb8798e9afa5512e6bbb8c6058c30fcd6404d390c2644"
    end
    # The arm64 url on Intel too: with none, brew fails with "requires at least a URL", not the
    # arch requirement.
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.23/duckdock-darwin-arm64"
      sha256 "58673f1808a6076cc0ddb8798e9afa5512e6bbb8c6058c30fcd6404d390c2644"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.23/duckdock-linux-x64.gz"
      sha256 "db2a97aee14ac848cafd7e0acf211367e17e5d984faa402e071b900ee23bff2f"
    end
    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.23/duckdock-linux-arm64.gz"
      sha256 "c96c6052ac7bbce20bfeafff16670df36a7f180128c2d774134ab5ef343b79ae"
    end
  end

  # Linux builds `duckdock host add` copies to remote hosts; it looks in ../lib/duckdock.
  resource "linux-x64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.23/duckdock-linux-x64.gz"
    sha256 "db2a97aee14ac848cafd7e0acf211367e17e5d984faa402e071b900ee23bff2f"
  end

  resource "linux-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.23/duckdock-linux-arm64.gz"
    sha256 "c96c6052ac7bbce20bfeafff16670df36a7f180128c2d774134ab5ef343b79ae"
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
