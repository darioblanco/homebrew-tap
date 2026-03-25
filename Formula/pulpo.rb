class Pulpo < Formula
  desc "Pulpo daemon + CLI for managing agent sessions"
  homepage "https://github.com/darioblanco/pulpo"
  version "0.0.37"
  license any_of: ["MIT", "Apache-2.0"]

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/darioblanco/pulpo/releases/download/v0.0.37/pulpod-aarch64-apple-darwin.tar.xz"
      sha256 "3d8125e83686c7932f6a6e9fb202262e1968909dd7d1563df769e06b81c79948"
    end
    if Hardware::CPU.intel?
      url "https://github.com/darioblanco/pulpo/releases/download/v0.0.37/pulpod-x86_64-apple-darwin.tar.xz"
      sha256 "0761d6805b0c089e822968eb87bc4f7b6896d096c2fc8ec903cbfb97c795f2ef"
    end
  end

  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/darioblanco/pulpo/releases/download/v0.0.37/pulpod-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "db3e7384d454e024fe5abeacf80eec6f4764a35d5465c01af5ecaaac30a83e5f"
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
