class PulpoCli < Formula
  desc "Pulpo CLI — manage agent sessions from the terminal"
  homepage "https://github.com/darioblanco/pulpo"
  version "0.0.41"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/darioblanco/pulpo/releases/download/v0.0.41/pulpo-cli-aarch64-apple-darwin.tar.xz"
      sha256 "db7f0a05c08e2f6367c84502d578fe096e21e9dcf582ec84f1f28faeddfa5bb4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/darioblanco/pulpo/releases/download/v0.0.41/pulpo-cli-x86_64-apple-darwin.tar.xz"
      sha256 "1cf7b8412c634e7bf455c6271623220358feaa1a15d11d10e21bbfe1c7db55b1"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/darioblanco/pulpo/releases/download/v0.0.41/pulpo-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "55a71cf3ded343c127ee174567e938d4568e801851997aee22a664adcbaea03c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/darioblanco/pulpo/releases/download/v0.0.41/pulpo-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6942c3192bdde1a24876c24cbc4571a3e594daa3d32254abee977dab6a49bdb3"
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
