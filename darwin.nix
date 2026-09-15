{ username, ... }:

{
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  system.primaryUser = username;
  system.stateVersion = 6;

  users.users.${username} = {
    name = username;
    home = "/Users/${username}";
  };
}
