class Duckdock < Formula
  desc "Run Claude Code, Codex and opencode sessions on your SSH hosts from one TUI"
  homepage "https://github.com/askrubberduck/homebrew-tap"
  version "0.2.3"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.3/duckdock-darwin-arm64"
      sha256 "7b9264ab60d43136dc1a33a415dd803265e3d74ad30da3aa1165323ceffdcff8"
    end
    # The arm64 url on Intel too: with none, brew fails with "requires at least a URL", not the
    # arch requirement.
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.3/duckdock-darwin-arm64"
      sha256 "7b9264ab60d43136dc1a33a415dd803265e3d74ad30da3aa1165323ceffdcff8"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.3/duckdock-linux-x64.gz"
      sha256 "c9b2d4b84fb53ac5c945a60dd6721d47f3b0e8961579da3640e9b3259c224feb"
    end
    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.3/duckdock-linux-arm64.gz"
      sha256 "0c6d92127f603af67727bef87b7731d1b6cd1e27963cd4bd79541e8b1dde29cf"
    end
  end

  # Linux builds `duckdock host add` copies to remote hosts; it looks in ../lib/duckdock.
  resource "linux-x64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.3/duckdock-linux-x64.gz"
    sha256 "c9b2d4b84fb53ac5c945a60dd6721d47f3b0e8961579da3640e9b3259c224feb"
  end

  resource "linux-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.3/duckdock-linux-arm64.gz"
    sha256 "0c6d92127f603af67727bef87b7731d1b6cd1e27963cd4bd79541e8b1dde29cf"
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
