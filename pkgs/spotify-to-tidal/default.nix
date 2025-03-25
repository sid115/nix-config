{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "spotify-to-tidal";
  version = "1.0.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "spotify2tidal";
    repo = "spotify_to_tidal";
    rev = "v${version}";
    hash = "sha256-NexwO4Qwv1P58QAgBHPfCf4Q/mhTicWHaRubh8En9AE=";
  };

  build-system = [
    python3.pkgs.setuptools
    python3.pkgs.wheel
  ];

  dependencies = with python3.pkgs; [
    pytest
    pytest-mock
    pyyaml
    spotipy
    sqlalchemy
    tidalapi
    tqdm
  ];

  pythonImportsCheck = [
    "spotify_to_tidal"
  ];

  meta = {
    description = "A command line tool for importing your Spotify playlists into Tidal";
    homepage = "https://github.com/spotify2tidal/spotify_to_tidal";
    license = lib.licenses.agpl3Only;
    mainProgram = "spotify-to-tidal";
  };
}
