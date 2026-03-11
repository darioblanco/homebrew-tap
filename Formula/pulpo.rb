class Pulpo < Formula
  desc "Pulpo daemon + CLI for managing agent sessions"
  homepage "https://github.com/darioblanco/pulpo"
  version "0.0.16"
  license any_of: ["MIT", "Apache-2.0"]

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/darioblanco/pulpo/releases/download/v0.0.16/pulpod-aarch64-apple-darwin.tar.xz"
      sha256 "89fea983a57e3b9d51260f4de646914a36ac93c33b0517527bdee7cd0960612b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/darioblanco/pulpo/releases/download/v0.0.16/pulpod-x86_64-apple-darwin.tar.xz"
      sha256 "6a0e21a7ece9a85e2b45ff4dedb3a421677bb071e557b7cfc435e177be47fd59"
    end
  end

  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/darioblanco/pulpo/releases/download/v0.0.16/pulpod-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "8d299d3091675e491aa2439bf985e72f8ef065072cd59eedef693002d8a60080"
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
