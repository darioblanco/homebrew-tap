class Pulpo < Formula
  desc "Pulpo daemon + CLI for managing agent sessions"
  homepage "https://github.com/darioblanco/pulpo"
  version "0.0.8"
  license any_of: ["MIT", "Apache-2.0"]

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/darioblanco/pulpo/releases/download/v0.0.8/pulpod-aarch64-apple-darwin.tar.xz"
      sha256 "8cf80d12e40f1b82df40fd1d47ac7328de3128e5a9a6d9fd69331d18162dddae"
    end
    if Hardware::CPU.intel?
      url "https://github.com/darioblanco/pulpo/releases/download/v0.0.8/pulpod-x86_64-apple-darwin.tar.xz"
      sha256 "4b2e1b980642641f440bc35fb246475bfac998703894457490a00bba668ff82f"
    end
  end

  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/darioblanco/pulpo/releases/download/v0.0.8/pulpod-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "82ed4a188b94591f869809d84e0fb579510bc9d416faa6899feb0abfdad70dc2"
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
