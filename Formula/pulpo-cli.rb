class PulpoCli < Formula
  desc "Pulpo CLI — manage agent sessions from the terminal"
  homepage "https://github.com/darioblanco/pulpo"
  version "0.0.32"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/darioblanco/pulpo/releases/download/v0.0.32/pulpo-cli-aarch64-apple-darwin.tar.xz"
      sha256 "95c991e79bfbfcc409842e9356f899517eb353de9344ca4a411c6f1c3993d0d2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/darioblanco/pulpo/releases/download/v0.0.32/pulpo-cli-x86_64-apple-darwin.tar.xz"
      sha256 "25f86df4b63935c3636c9b4d0818fa466f28b8ae91b8cb16739844a2aa23e8db"
    end
  end
  if OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/darioblanco/pulpo/releases/download/v0.0.32/pulpo-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "221c0b353596c410183635c081ccf6478f36e8f9109c7e13cea7b68a2c15033d"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin": {},
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
