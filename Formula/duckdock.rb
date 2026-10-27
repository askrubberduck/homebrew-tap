class Duckdock < Formula
  desc "Run Claude Code, Codex and opencode sessions on your SSH hosts from one TUI"
  homepage "https://github.com/askrubberduck/homebrew-tap"
  version "0.2.48"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.48/duckdock-darwin-arm64"
      sha256 "452a73bae268d7927a2a2b38999b3be669c5e66206ed42234affeb801ad478ac"
    end
    # The arm64 url on Intel too: with none, brew fails with "requires at least a URL", not the
    # arch requirement.
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.48/duckdock-darwin-arm64"
      sha256 "452a73bae268d7927a2a2b38999b3be669c5e66206ed42234affeb801ad478ac"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.48/duckdock-linux-x64.gz"
      sha256 "f55fbc40503794eae31f69015e3f06e75ef36118815daa42a7038ddce69c719d"
    end
    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.48/duckdock-linux-arm64.gz"
      sha256 "fb48c73132fcbd10d2e0f0cae8c71407d95c56576127c071d0e76ab3d6051d5f"
    end
  end

  # Linux builds `duckdock host add` copies to remote hosts; it looks in ../lib/duckdock.
  resource "linux-x64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.48/duckdock-linux-x64.gz"
    sha256 "f55fbc40503794eae31f69015e3f06e75ef36118815daa42a7038ddce69c719d"
  end

  resource "linux-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.48/duckdock-linux-arm64.gz"
    sha256 "fb48c73132fcbd10d2e0f0cae8c71407d95c56576127c071d0e76ab3d6051d5f"
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
