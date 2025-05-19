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

    settings = {
      # binary caches
      # substituters = [
      #   "https://cache.portuus.de"
      # ];
      # trusted-public-keys = [
      #   "cache.portuus.de:INZRjwImLIbPbIx8Qp38gTVmSNL0PYE4qlkRzQY2IAU="
      # ];
    };
  };
}
