class Pulpo < Formula
  desc "Pulpo daemon + CLI for managing agent sessions"
  homepage "https://github.com/darioblanco/pulpo"
  version "0.1.1"
  license any_of: ["MIT", "Apache-2.0"]

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/darioblanco/pulpo/releases/download/v0.1.1/pulpod-aarch64-apple-darwin.tar.xz"
      sha256 "a6b05250aee9222a4f7efad0a2129835e917579e0c69d440ccf55cb5900addec"
    end
    if Hardware::CPU.intel?
      url "https://github.com/darioblanco/pulpo/releases/download/v0.1.1/pulpod-x86_64-apple-darwin.tar.xz"
      sha256 "70b9822e9f41e28fdfe6a6f8b0ca499a6902cc2137693542cc25fb39a4a630f9"
    end
  end

  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/darioblanco/pulpo/releases/download/v0.1.1/pulpod-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "3f4e4d133aa8e0783c440af87d7b06723ee546272188e5ef4c2bbbe0dd63ff2f"
    end
  end

  depends_on "pulpo-cli"
  depends_on "tmux"

  def install
    bin.install "pulpod"
  end

  service do
    run [opt_bin/"pulpod"]
    keep_alive true
    log_path var/"log/pulpo.log"
    error_log_path var/"log/pulpo.log"
    working_dir HOMEBREW_PREFIX
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pulpod --version")
    assert_match version.to_s, shell_output("#{Formula["pulpo-cli"].opt_bin}/pulpo --version")
  end

  def caveats
    <<~EOS
      pulpo requires at least one coding agent provider to be installed and authenticated.

      Claude Code:
        npm install -g @anthropic-ai/claude-code
        claude login

      OpenAI Codex:
        npm install -g @openai/codex

      Start daemon:
        brew services start pulpo

      Dashboard:
        http://localhost:7433
    EOS
  end
end
