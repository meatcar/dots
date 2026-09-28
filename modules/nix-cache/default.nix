{
  nix.settings = {
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://ghostty.cachix.org"
      "https://cache.numtide.com" # llm-agents.nix
      "https://nyx-cache.chaotic.cx" # chaotic (cachyos kernel)
    ];
    extra-trusted-substituters = [
      "https://nix-community.cachix.org"
      "https://ghostty.cachix.org"
      "https://cache.numtide.com"
      "https://nyx-cache.chaotic.cx"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "ghostty.cachix.org:QB389yTa6gTyneehvqG58y0WnHjQOqgnA+wBnpWWxns="
      "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
      "nyx-cache.chaotic.cx:dJxTrgMC3V3cFfyIiBQDQorG6k1LsqurH/srpMSq7qk="
    ];
  };
}
