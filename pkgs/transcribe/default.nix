{
  python3Packages,
  ...
}:

python3Packages.buildPythonApplication {
  pname = "transcribe";
  version = "1.0.0";

  src = ./.;
  pyproject = true;

  build-system = [ python3Packages.setuptools ];

  propagatedBuildInputs = [ python3Packages.openai ];

  doCheck = false;

  meta = {
    description = "Transcribe a given audio file using the OpenAI API.";
  };
}
