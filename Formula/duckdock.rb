class Duckdock < Formula
  desc "Run Claude Code, Codex and opencode sessions on your SSH hosts from one TUI"
  homepage "https://github.com/askrubberduck/homebrew-tap"
  version "0.2.25"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.25/duckdock-darwin-arm64"
      sha256 "65c8baaae4a3c25c651f15a42665353849b620016f18c42753d9b03d5bda6354"
    end
    # The arm64 url on Intel too: with none, brew fails with "requires at least a URL", not the
    # arch requirement.
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.25/duckdock-darwin-arm64"
      sha256 "65c8baaae4a3c25c651f15a42665353849b620016f18c42753d9b03d5bda6354"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.25/duckdock-linux-x64.gz"
      sha256 "d6c09ce5f4dbb405930eb763e0705507712e1ce7d948a509b5343aa9d8386f7c"
    end
    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.25/duckdock-linux-arm64.gz"
      sha256 "da05bbcb31009926dc238c2d08afe49b1833afc8bc291a9d797e3c802c51391c"
    end
  end

  # Linux builds `duckdock host add` copies to remote hosts; it looks in ../lib/duckdock.
  resource "linux-x64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.25/duckdock-linux-x64.gz"
    sha256 "d6c09ce5f4dbb405930eb763e0705507712e1ce7d948a509b5343aa9d8386f7c"
  end

  resource "linux-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.25/duckdock-linux-arm64.gz"
    sha256 "da05bbcb31009926dc238c2d08afe49b1833afc8bc291a9d797e3c802c51391c"
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
