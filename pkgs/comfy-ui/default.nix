{
  lib,
  python3,
  fetchFromGitHub,
}:

let
  comfyui-frontend-package = import ./comfyui-frontend-package.nix {
    inherit lib python3 fetchFromGitHub;
  };
in
python3.pkgs.buildPythonApplication rec {
  pname = "comfy-ui";
  version = "0.3.27";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "comfyanonymous";
    repo = "ComfyUI";
    rev = "v${version}";
    hash = "sha256-UGM2nrxveSEPuZAFY+Os0R1z/eWzlm8viG7sobis498=";
  };

  build-system = [
    python3.pkgs.setuptools
    python3.pkgs.wheel
  ];

  dependencies =
    [
      comfyui-frontend-package
    ]
    ++ (with python3.pkgs; [
      aiohttp
      av
      einops
      kornia
      numpy
      pillow
      psutil
      pyyaml
      safetensors
      scipy
      sentencepiece
      soundfile
      spandrel
      tokenizers
      torch
      torchaudio
      torchsde
      torchvision
      tqdm
      transformers
      yarl
    ]);

  pythonImportsCheck = [
    "comfy_ui"
  ];

  meta = {
    description = "The most powerful and modular diffusion model GUI, api and backend with a graph/nodes interface";
    homepage = "https://github.com/comfyanonymous/ComfyUI";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "comfy-ui";
  };
}
