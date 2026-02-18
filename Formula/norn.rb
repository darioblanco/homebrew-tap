class Norn < Formula
  desc "Agent session orchestrator for Tailscale networks"
  homepage "https://github.com/darioblanco/norn"
  version "0.1.0"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/darioblanco/norn/releases/download/v0.1.0/norn-0.1.0-darwin-arm64.tar.gz"
      sha256 "PLACEHOLDER"
    else
      url "https://github.com/darioblanco/norn/releases/download/v0.1.0/norn-0.1.0-darwin-x86_64.tar.gz"
      sha256 "PLACEHOLDER"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/darioblanco/norn/releases/download/v0.1.0/norn-0.1.0-linux-aarch64.tar.gz"
      sha256 "PLACEHOLDER"
    else
      url "https://github.com/darioblanco/norn/releases/download/v0.1.0/norn-0.1.0-linux-x86_64.tar.gz"
      sha256 "PLACEHOLDER"
    end
  end

  depends_on "tmux"

  def install
    bin.install "norn"
    bin.install "nornd"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/norn --version")
    assert_match version.to_s, shell_output("#{bin}/nornd --version")
  end

  def caveats
    <<~EOS
      norn requires a coding agent (Claude Code or OpenAI Codex) to be
      installed and authenticated before use.

      Claude Code (Max/Pro or API key):
        npm install -g @anthropic-ai/claude-code
        claude login

      OpenAI Codex:
        npm install -g @openai/codex
        export OPENAI_API_KEY=sk-...

      Start the daemon:
        nornd

      Then open http://localhost:7433 in your browser.
    EOS
  end
end
