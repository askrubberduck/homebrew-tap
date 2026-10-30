class Duckdock < Formula
  desc "Run Claude Code, Codex and opencode sessions on your SSH hosts from one TUI"
  homepage "https://github.com/askrubberduck/homebrew-tap"
  version "0.2.68"

  on_macos do
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.68/duckdock-darwin-arm64"
      sha256 "449e99349a118f607d6cb349ddbc4282910ff89929aad41568334654ef368ca6"
    end
    # The arm64 url on Intel too: with none, brew fails with "requires at least a URL", not the
    # arch requirement.
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.68/duckdock-darwin-arm64"
      sha256 "449e99349a118f607d6cb349ddbc4282910ff89929aad41568334654ef368ca6"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.68/duckdock-linux-x64.gz"
      sha256 "3d93265df2defbacef5393ce971dcf5b75c2f2950d958275e94c773603d28957"
    end
    on_arm do
      url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.68/duckdock-linux-arm64.gz"
      sha256 "06d4fa6c95b11f2545dba52d004db4996a97d4cd1cfdcf52bd1665e505eb1fee"
    end
  end

  # Linux builds `duckdock host add` copies to remote hosts; it looks in ../lib/duckdock.
  resource "linux-x64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.68/duckdock-linux-x64.gz"
    sha256 "3d93265df2defbacef5393ce971dcf5b75c2f2950d958275e94c773603d28957"
  end

  resource "linux-arm64" do
    url "https://github.com/askrubberduck/homebrew-tap/releases/download/duckdock-0.2.68/duckdock-linux-arm64.gz"
    sha256 "06d4fa6c95b11f2545dba52d004db4996a97d4cd1cfdcf52bd1665e505eb1fee"
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
