class Pulpo < Formula
  desc "Pulpo daemon + CLI for managing agent sessions"
  homepage "https://github.com/darioblanco/pulpo"
  version "0.4.0"
  license any_of: ["MIT", "Apache-2.0"]

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/darioblanco/pulpo/releases/download/v0.4.0/pulpod-aarch64-apple-darwin.tar.xz"
      sha256 "5c48a3b8171bf9b826f9f0829b2ecd7b7a89762887e14242e5bbe3913f4cc874"
    end
    if Hardware::CPU.intel?
      url "https://github.com/darioblanco/pulpo/releases/download/v0.4.0/pulpod-x86_64-apple-darwin.tar.xz"
      sha256 "90dfd992e4fbd447a812a292f5437dc7f101e01effdc0ca569393e73ee630087"
    end
  end

  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/darioblanco/pulpo/releases/download/v0.4.0/pulpod-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "3a06a7ab0a4cdb0cafa189c15f3d0aa871fed52a7ce70cd7ca11779159f21329"
    end
    if Hardware::CPU.arm?
      url "https://github.com/darioblanco/pulpo/releases/download/v0.4.0/pulpod-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "75c3e7c067f3181f30969091ee7e767fdebc121a1002dad8d0b7fbe1ae3bb4f9"
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
