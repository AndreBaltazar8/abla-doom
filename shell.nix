{ pkgs ? import (builtins.fetchTarball {
    name = "nixpkgs-5e2a59a5b1a82f89f2c7e598302a9cacebb72a67";
    url = "https://github.com/NixOS/nixpkgs/archive/5e2a59a5b1a82f89f2c7e598302a9cacebb72a67.tar.gz";
    sha256 = "02rf59xj2v1ml7v35x4j64ax1fb7xx96ld7va6rifyxazmwsr4rb";
  }) {} }:

pkgs.mkShell {
  packages = with pkgs; [
    gcc
    gnumake
    imagemagick
    libglvnd
    llvmPackages.llvm
    llvmPackages.clang
    llvmPackages.lld
    mesa
    openssl
    ripgrep
    vulkan-loader
    xorg.libX11
    xorg.xorgserver
    xorg.xwininfo
    xvfb-run
  ];

  shellHook = ''
    export ABLA_DOOM_LVP_ICD="${pkgs.mesa}/share/vulkan/icd.d/lvp_icd.x86_64.json"
    export ABLA_DOOM_EGL_VENDOR="${pkgs.mesa}/share/glvnd/egl_vendor.d/50_mesa.json"
    export ABLA_DOOM_DRI="${pkgs.mesa}/lib/dri"
    export LD_LIBRARY_PATH="${pkgs.openssl.out}/lib:${pkgs.vulkan-loader}/lib:${pkgs.libglvnd}/lib:${pkgs.mesa}/lib:${pkgs.xorg.libX11}/lib''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
  '';
}
