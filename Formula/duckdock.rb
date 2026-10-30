class Duckdock < Formula
  desc "Run Claude Code, Codex and opencode sessions on your SSH hosts from one TUI"
  homepage "https://github.com/askrubberduck/homebrew-tap"
  version "0.2.63"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.63/duckdock-darwin-arm64"
      sha256 "4d3ebdae1f654364165a60679481009d8d86f2fe25772148d26111b768a55244"
    end
    # The arm64 url on Intel too: with none, brew fails with "requires at least a URL", not the
    # arch requirement.
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.63/duckdock-darwin-arm64"
      sha256 "4d3ebdae1f654364165a60679481009d8d86f2fe25772148d26111b768a55244"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.63/duckdock-linux-x64.gz"
      sha256 "ee8b6f02d8494a3301648d6fc66a6bdad3f5bc4d9f173300a75137d504348a9a"
    end
    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.63/duckdock-linux-arm64.gz"
      sha256 "0129093681a3701c862ce518be8ab93ae485587d9f9e31d459fc6511c8470caf"
    end
  end

  # Linux builds `duckdock host add` copies to remote hosts; it looks in ../lib/duckdock.
  resource "linux-x64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.63/duckdock-linux-x64.gz"
    sha256 "ee8b6f02d8494a3301648d6fc66a6bdad3f5bc4d9f173300a75137d504348a9a"
  end

  resource "linux-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.63/duckdock-linux-arm64.gz"
    sha256 "0129093681a3701c862ce518be8ab93ae485587d9f9e31d459fc6511c8470caf"
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
