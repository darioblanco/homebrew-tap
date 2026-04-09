class Pulpod < Formula
  desc "Pulpo daemon — manages agent sessions via tmux/Docker"
  homepage "https://github.com/darioblanco/pulpo"
  version "0.0.43"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/darioblanco/pulpo/releases/download/v0.0.43/pulpod-aarch64-apple-darwin.tar.xz"
      sha256 "71128d11924025d3eaa3546027b7417eab19fd7a24afc354e0fc67feb5dc8c73"
    end
    if Hardware::CPU.intel?
      url "https://github.com/darioblanco/pulpo/releases/download/v0.0.43/pulpod-x86_64-apple-darwin.tar.xz"
      sha256 "aa02c0b0749b19304d5876f6ec4cf466dfe49c3bd27d339ecc0f781d2b42921f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/darioblanco/pulpo/releases/download/v0.0.43/pulpod-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "1e18dd6e7a134eb5e1b341cd1a21e18c767d8e0f8335474dacd9cb37190d5733"
    end
    if Hardware::CPU.intel?
      url "https://github.com/darioblanco/pulpo/releases/download/v0.0.43/pulpod-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "946bb3f1337bbe6d8bfa680da4f2fb1935dec7ac86e1287c00c8915f8c18b858"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin": {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin": {},
    "x86_64-pc-windows-gnu": {},
    "x86_64-unknown-linux-gnu": {}
  }

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "pulpod"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "pulpod"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "pulpod"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "pulpod"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
