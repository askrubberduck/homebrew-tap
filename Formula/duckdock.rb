class Duckdock < Formula
  desc "Run Claude Code, Codex and opencode sessions on your SSH hosts from one TUI"
  homepage "https://github.com/askrubberduck/homebrew-tap"
  version "0.2.69"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.69/duckdock-darwin-arm64"
      sha256 "13043d0232431cdf9d61ef985d1c150d499634c8243a900e6d0e6362c64bd46c"
    end
    # The arm64 url on Intel too: with none, brew fails with "requires at least a URL", not the
    # arch requirement.
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.69/duckdock-darwin-arm64"
      sha256 "13043d0232431cdf9d61ef985d1c150d499634c8243a900e6d0e6362c64bd46c"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.69/duckdock-linux-x64.gz"
      sha256 "c806bfe34593b8fa719d2af8c3e1f9ffa4d6be7d3be762ab327c25a476446301"
    end
    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.69/duckdock-linux-arm64.gz"
      sha256 "a7bd0ac533efcf3b8038e7d80013838683dec3ce6b04124ca6043b09bbed3d0d"
    end
  end

  # Linux builds `duckdock host add` copies to remote hosts; it looks in ../lib/duckdock.
  resource "linux-x64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.69/duckdock-linux-x64.gz"
    sha256 "c806bfe34593b8fa719d2af8c3e1f9ffa4d6be7d3be762ab327c25a476446301"
  end

  resource "linux-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.69/duckdock-linux-arm64.gz"
    sha256 "a7bd0ac533efcf3b8038e7d80013838683dec3ce6b04124ca6043b09bbed3d0d"
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
