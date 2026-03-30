class Pulpo < Formula
  desc "Pulpo daemon + CLI for managing agent sessions"
  homepage "https://github.com/darioblanco/pulpo"
  version "0.0.41"
  license any_of: ["MIT", "Apache-2.0"]

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/darioblanco/pulpo/releases/download/v0.0.41/pulpod-aarch64-apple-darwin.tar.xz"
      sha256 "468134dda045d49f65bcd2684ce181a1bc53334778da896739474a6a061e8626"
    end
    if Hardware::CPU.intel?
      url "https://github.com/darioblanco/pulpo/releases/download/v0.0.41/pulpod-x86_64-apple-darwin.tar.xz"
      sha256 "5e52a4808557986692bbd954792d2f5a78ec598f17e2aa163e235b60d6a10a8a"
    end
  end

  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/darioblanco/pulpo/releases/download/v0.0.41/pulpod-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e821bfbf804b329c2eac633bff82919151320b7556f394d8101ffa868549e170"
    end
    if Hardware::CPU.arm?
      url "https://github.com/darioblanco/pulpo/releases/download/v0.0.41/pulpod-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "54ccbe223d8e90d4ac9f62acb32348181e4ee78b7d8f163b1793f65d87b9a3e5"
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
    environment_variables PATH: "#{HOMEBREW_PREFIX}/bin:#{HOMEBREW_PREFIX}/sbin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pulpod --version")
    assert_match version.to_s, shell_output((Formula["pulpo-cli"].opt_bin/"pulpo").to_s + " --version")
  end

  def caveats
    <<~EOS
      pulpo runs any command in managed tmux sessions. No agent is required,
      but here are some popular coding agents you can use:

      Claude Code:    npm install -g @anthropic-ai/claude-code
      OpenAI Codex:   npm install -g @openai/codex
      Gemini CLI:     npm install -g @google/gemini-cli
      Aider:          pip install aider-chat
      OpenCode:       go install github.com/opencode-ai/opencode@latest

      Start daemon:
        brew services start pulpo

      Dashboard:
        http://localhost:7433
    EOS
  end
end
