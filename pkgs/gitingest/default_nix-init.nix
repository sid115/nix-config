{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "gitingest";
  version = "0.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "coderamp-labs";
    repo = "gitingest";
    rev = "v${version}";
    hash = "sha256-drsncGneZyOCC2GJbrDM+bf4QGI2luacxMhrmdk03l4=";
  };

  build-system = [
    python3.pkgs.setuptools
    python3.pkgs.wheel
  ];

  dependencies = with python3.pkgs; [
    click
    httpx
    loguru
    pathspec
    pydantic
    python-dotenv
    starlette
    strenum
    tiktoken
    typing-extensions
  ];

  optional-dependencies = with python3.pkgs; {
    dev = [
      eval-type-backport
      pre-commit
      pytest
      pytest-asyncio
      pytest-cov
      pytest-mock
    ];
    server = [
      boto3
      fastapi
      prometheus-client
      sentry-sdk
      slowapi
      uvicorn
    ];
  };

  pythonImportsCheck = [
    "gitingest"
  ];

  meta = {
    description = "Replace 'hub' with 'ingest' in any GitHub URL to get a prompt-friendly extract of a codebase";
    homepage = "https://github.com/coderamp-labs/gitingest";
    changelog = "https://github.com/coderamp-labs/gitingest/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "gitingest";
  };
}
