{
  nix = {
    # TODO: add distributed build support for portuus.de
    # distributedBuilds = true;
    # buildMachines = [
    #   {
    #     hostName = "portuus.de";
    #     supportedFeatures = [
    #       "benchmark"
    #       "big-parallel"
    #       "kvm"
    #       "nixos-test"
    #     ];
    #     maxJobs = 8;
    #     system = "x86_64-linux";
    #   }
    # ];

    #  auto run garbage collection when out of space
    extraOptions = ''
      min-free = ${toString (100 * 1024 * 1024)}
      max-free = ${toString (1024 * 1024 * 1024)}
    '';

    # auto run garbage collection once a week
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };

    # flake alias for nix-core
    registry = {
      core = {
        from = {
          id = "core";
          type = "indirect";
        };
        to = {
          owner = "sid115";
          repo = "nix-core";
          type = "github";
        };
      };
    };

    settings = {
      # binary caches
      substituters = [
        "https://nix-community.cachix.org"
        "https://cache.portuus.de"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "cache.portuus.de:INZRjwImLIbPbIx8Qp38gTVmSNL0PYE4qlkRzQY2IAU="
      ];
    };
  };
}
