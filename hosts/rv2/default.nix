{ inputs, outputs, ... }:

{
  imports = [
    ./boot.nix
    ./docker.nix
    ./hardware.nix
    ./packages.nix

    ../../users/sid

    inputs.core.nixosModules.common
    inputs.core.nixosModules.device.laptop
    inputs.core.nixosModules.hyprland
    inputs.core.nixosModules.openssh
    inputs.core.nixosModules.virtualization

    outputs.nixosModules.common
    outputs.nixosModules.docs
  ];

  networking.hostName = "rv2";

  programs.htop = {
    enable = true;
    settings = {
      highlight_base_name = 1;
      # Beware! This file is rewritten by htop when settings are changed in the interface.
      # The parser is also very primitive, and not human-friendly.
      # htop_version=3.4.1
      # config_reader_min_version=3
      # fields=0 48 17 18 38 39 40 2 46 47 49 1
      # hide_kernel_threads=1
      # hide_userland_threads=0
      # hide_running_in_container=0
      # shadow_other_users=0
      # show_thread_names=0
      # show_program_path=0
      # highlight_base_name=1
      # highlight_deleted_exe=1
      # shadow_distribution_path_prefix=0
      # highlight_megabytes=1
      # highlight_threads=1
      # highlight_changes=0
      # highlight_changes_delay_secs=5
      # find_comm_in_cmdline=1
      # strip_exe_from_cmdline=1
      # show_merged_command=0
      # header_margin=1
      # screen_tabs=1
      # detailed_cpu_time=0
      # cpu_count_from_one=0
      # show_cpu_usage=1
      # show_cpu_frequency=1
      # show_cpu_temperature=1
      # degree_fahrenheit=0
      # show_cached_memory=1
      # update_process_names=0
      # account_guest_in_cpu_meter=0
      # color_scheme=0
      # enable_mouse=1
      # delay=15
      # hide_function_bar=0
      # header_layout=two_50_50
      # column_meters_0=LeftCPUs2 Memory Swap
      # column_meter_modes_0=1 1 1
      # column_meters_1=RightCPUs2 Tasks LoadAverage Uptime
      # column_meter_modes_1=1 2 2 2
      # tree_view=1
      # sort_key=46
      # tree_sort_key=0
      # sort_direction=-1
      # tree_sort_direction=1
      # tree_view_always_by_pid=0
      # all_branches_collapsed=1
      # screen:Main=PID USER PRIORITY NICE M_VIRT M_RESIDENT M_SHARE STATE PERCENT_CPU PERCENT_MEM TIME Command
      # .sort_key=PERCENT_CPU
      # .tree_sort_key=PID
      # .tree_view_always_by_pid=0
      # .tree_view=1
      # .sort_direction=-1
      # .tree_sort_direction=1
      # .all_branches_collapsed=1
      # screen:I/O=PID USER IO_PRIORITY IO_RATE IO_READ_RATE IO_WRITE_RATE PERCENT_SWAP_DELAY PERCENT_IO_DELAY Command
      # .sort_key=IO_RATE
      # .tree_sort_key=PID
      # .tree_view_always_by_pid=0
      # .tree_view=0
      # .sort_direction=-1
      # .tree_sort_direction=1
      # .all_branches_collapsed=0
    };
  };

  programs.adb.enable = true;
  users.users.sid.extraGroups = [
    "adbusers"
    "kvm"
  ];

  services = {
    openssh.enable = true;
  };

  boot.binfmt.emulatedSystems = [
    "aarch64-linux"
  ];

  normalUsers = {
    sid = {
      extraGroups = [
        "audio"
        "dialout"
        "floppy"
        "input"
        "libvirtd"
        "lp"
        "networkmanager"
        "video"
      ];
    };
  };

  time.hardwareClockInLocalTime = true; # Windows compatibility

  system.stateVersion = "25.05";
}
