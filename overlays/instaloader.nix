final: prev:

{
  instaloader = prev.instaloader.overrideAttrs (oldAttrs: {
    src = prev.pkgs.fetchFromGitHub {
      owner = "instaloader";
      repo = "instaloader";
      rev = "pull/2533/head";
      sha256 = "sha256-LMRU49pyAWDdflPbA4cZ9pIdjGNThLWfZWZsQkcvTs4=";
    };
  });
}
