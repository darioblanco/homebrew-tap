class PulpoCli < Formula
  desc "Pulpo CLI — manage agent sessions from the terminal"
  homepage "https://github.com/darioblanco/pulpo"
  version "0.0.12"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/darioblanco/pulpo/releases/download/v0.0.12/pulpo-cli-aarch64-apple-darwin.tar.xz"
      sha256 "73282dd085eb59a60b904e8cb67733039c05e7f9a004fc0829cd567dddd47502"
    end
    if Hardware::CPU.intel?
      url "https://github.com/darioblanco/pulpo/releases/download/v0.0.12/pulpo-cli-x86_64-apple-darwin.tar.xz"
      sha256 "675ae6a5f282f1dbff14420899460be6a39d85b6ab3562b24e29a6ab0cc0b2ec"
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/darioblanco/pulpo/releases/download/v0.0.12/pulpo-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f4a769925394c4a8c85c514dd0e9a43a9808b1015af2e74e5935da35e15a57f5"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin": {},
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
