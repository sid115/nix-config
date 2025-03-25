{
  python3,
  ...
}:

python3.pkgs.buildPythonApplication {
  pname = "transcribe";
  version = "1.0.0";

  src = ./.;

  propagatedBuildInputs = [ python3.pkgs.openai ];

  doCheck = false;

  meta = {
    description = "Transcribe a given audio file using the OpenAI API.";
  };
}
