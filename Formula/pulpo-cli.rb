class PulpoCli < Formula
  desc "Pulpo CLI — manage agent sessions from the terminal"
  homepage "https://github.com/darioblanco/pulpo"
  version "0.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/darioblanco/pulpo/releases/download/v0.4.0/pulpo-cli-aarch64-apple-darwin.tar.xz"
      sha256 "ae93558e12a3c6aa1f9ec317bce567325bb813cd20ceb5720f7d888e83b20752"
    end
    if Hardware::CPU.intel?
      url "https://github.com/darioblanco/pulpo/releases/download/v0.4.0/pulpo-cli-x86_64-apple-darwin.tar.xz"
      sha256 "4012818a422b654bc9227805169ed360cd3ff4f87904401c788277ba57ec858a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/darioblanco/pulpo/releases/download/v0.4.0/pulpo-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "bcff9800d49dc33c4d80007095e8e583aaaf343f25eb3e5a3b2dce6d384721b3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/darioblanco/pulpo/releases/download/v0.4.0/pulpo-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "949e17e234c40d4113cd91b62ee44cbc1615aa0f57c94ad8d8de534e3b7fe796"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin": {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin": {},
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
      bin.install "pulpo"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "pulpo"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "pulpo"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "pulpo"
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
