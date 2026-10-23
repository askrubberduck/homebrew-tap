class Duckdock < Formula
  desc "Run Claude Code, Codex and opencode sessions on your SSH hosts from one TUI"
  homepage "https://github.com/askrubberduck/homebrew-tap"
  version "0.2.29"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.29/duckdock-darwin-arm64"
      sha256 "d4482389cb0c3a92b068c822ae9728a4424041281e69e97a864cf68ab0dea2f7"
    end
    # The arm64 url on Intel too: with none, brew fails with "requires at least a URL", not the
    # arch requirement.
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.29/duckdock-darwin-arm64"
      sha256 "d4482389cb0c3a92b068c822ae9728a4424041281e69e97a864cf68ab0dea2f7"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.29/duckdock-linux-x64.gz"
      sha256 "109df5f294ce603257862db1838e25e5cba566fd3f654414c5cf45d1bc9acbdf"
    end
    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.29/duckdock-linux-arm64.gz"
      sha256 "746a7793052144ffe54ee58fec1f19401e472bd93e10c0c76dcc313aab612cf9"
    end
  end

  # Linux builds `duckdock host add` copies to remote hosts; it looks in ../lib/duckdock.
  resource "linux-x64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.29/duckdock-linux-x64.gz"
    sha256 "109df5f294ce603257862db1838e25e5cba566fd3f654414c5cf45d1bc9acbdf"
  end

  resource "linux-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.29/duckdock-linux-arm64.gz"
    sha256 "746a7793052144ffe54ee58fec1f19401e472bd93e10c0c76dcc313aab612cf9"
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
