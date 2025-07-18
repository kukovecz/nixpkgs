{
  lib,
  python3Packages,
  fetchPypi,
}:

python3Packages.buildPythonApplication rec {
  pname = "lesscpy";
  version = "0.15.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-EEXRepj2iGRsp1jf8lTm6cA3RWSOBRoIGwOVw7d8gkw=";
  };

  checkInputs = with python3Packages; [ pytestCheckHook ];
  pythonImportsCheck = [ "lesscpy" ];
  propagatedBuildInputs = with python3Packages; [
    ply
    six
  ];

  doCheck = false; # Really weird test failures (`nix-build-python2.css not found`)

  meta = with lib; {
    description = "Python LESS Compiler";
    mainProgram = "lesscpy";
    homepage = "https://github.com/lesscpy/lesscpy";
    license = licenses.mit;
    maintainers = with maintainers; [ s1341 ];
  };
}
