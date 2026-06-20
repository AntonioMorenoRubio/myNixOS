{ pkgs, pkgs-unstable, ... }: {
home.packages =
    (with pkgs; [
      llama-cpp
      lmstudio
    ])
    ++
    (with pkgs-unstable; [
      opencode
      rtk
    ]);
}