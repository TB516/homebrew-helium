cask "helium-browser-linux" do
  arch arm: "arm64", intel: "x86_64"
  os linux: "linux"

  version "0.11.7.1"
  sha256 arm64_linux:  "444fce201cf360ee6af710ae81450ce3aae4eb97a5963238982549e49c0113e4",
         x86_64_linux: "57476b02588a07c1c59310c6f48f9b3d384b1f423f709a46f76bf768e45a5ff6"

  url "https://github.com/imputnet/helium-linux/releases/download/#{version}/helium-#{version}-#{arch}_linux.tar.xz"
  name "Helium"
  desc "Private, fast, and honest web browser"
  homepage "https://helium.computer/"

  livecheck do
    url "https://github.com/imputnet/helium-linux/releases"
    strategy :github_latest
  end

  binary "helium-#{version}-#{arch}_linux/helium-wrapper", target: "helium"
  artifact "helium-#{version}-#{arch}_linux/helium.desktop",
           target: "#{ENV["XDG_DATA_HOME"] || "#{Dir.home}/.local/share"}/applications/helium.desktop"
  artifact "helium-#{version}-#{arch}_linux/product_logo_256.png",
           target: "#{ENV["XDG_DATA_HOME"] || "#{Dir.home}/.local/share"}/icons/hicolor/256x256/apps/helium.png"

  preflight do
    xdg_data_home = ENV["XDG_DATA_HOME"] || "#{Dir.home}/.local/share"

    FileUtils.mkdir_p "#{xdg_data_home}/applications"
    FileUtils.mkdir_p "#{xdg_data_home}/icons/hicolor/256x256/apps"

    desktop_file = "#{staged_path}/helium-#{version}-#{arch}_linux/helium.desktop"
    contents = File.read(desktop_file)

    brew_exec = "#{HOMEBREW_PREFIX}/bin/helium"

    contents.gsub!(/^Exec=helium(.*)$/, "Exec=#{brew_exec}\\1")
    contents.gsub!(/^StartupNotify=true$/, "StartupNotify=false")

    File.write(desktop_file, contents)
  end

  zap delete: [
    "~/.cache/net.imput.helium",
    "~/.config/net.imput.helium",
  ]
end
