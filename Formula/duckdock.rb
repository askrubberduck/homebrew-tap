class Duckdock < Formula
  desc "Run Claude Code, Codex and opencode sessions on your SSH hosts from one TUI"
  homepage "https://github.com/askrubberduck/homebrew-tap"
  version "0.2.47"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.47/duckdock-darwin-arm64"
      sha256 "cc6b4b35e5382fe8965f1249eb5c66f03d50ec8ec3dbeae2332134352c7d6ef4"
    end
    # The arm64 url on Intel too: with none, brew fails with "requires at least a URL", not the
    # arch requirement.
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.47/duckdock-darwin-arm64"
      sha256 "cc6b4b35e5382fe8965f1249eb5c66f03d50ec8ec3dbeae2332134352c7d6ef4"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.47/duckdock-linux-x64.gz"
      sha256 "dce100a25ef23857a295e6ea3dc81b014cf915d6283dfc7fc7559c466674431a"
    end
    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.47/duckdock-linux-arm64.gz"
      sha256 "401a87fea828a231a5539d1fcccdacf8c112b97691301e94a5ef8394d2383c93"
    end
  end

  # Linux builds `duckdock host add` copies to remote hosts; it looks in ../lib/duckdock.
  resource "linux-x64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.47/duckdock-linux-x64.gz"
    sha256 "dce100a25ef23857a295e6ea3dc81b014cf915d6283dfc7fc7559c466674431a"
  end

  resource "linux-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.47/duckdock-linux-arm64.gz"
    sha256 "401a87fea828a231a5539d1fcccdacf8c112b97691301e94a5ef8394d2383c93"
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
