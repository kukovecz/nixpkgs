{
  lib,
  python3Packages,
  fetchFromGitHub,
  fetchpatch,
  qt5,
}:
python3Packages.buildPythonApplication rec {
  pname = "labelImg";
  version = "1.8.6";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "HumanSignal";
    repo = "labelImg";
    tag = "v${version}";
    hash = "sha256-RJxCtiDOePajlrjy9cpKETSKsWlH/Dlu1iFMj2aO4XU=";
  };

  nativeBuildInputs = with python3Packages; [
    pyqt5
    qt5.wrapQtAppsHook
  ];

  patches = [
    # fixes https://github.com/heartexlabs/labelImg/issues/838
    # can be removed after next upstream version bump
    (fetchpatch {
      url = "https://github.com/heartexlabs/labelImg/commit/5c38b6bcddce895d646e944e3cddcb5b43bf8b8b.patch";
      hash = "sha256-BmbnJS95RBfoNQT0E6JDJ/IZfBa+tv1C69+RVOSFdRA=";
    })
  ];

  dependencies = with python3Packages; [
    distutils
    pyqt5
    lxml
  ];

  preBuild = ''
    make qt5py3
  '';

  postInstall = ''
    install -Dm644 libs/resources.py $out/${python3Packages.python.sitePackages}/libs
  '';

  dontWrapQtApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${qtWrapperArgs[@]}")
  '';

  meta = {
    description = "Graphical image annotation tool and label object bounding boxes in images";
    mainProgram = "labelImg";
    homepage = "https://github.com/HumanSignal/labelImg";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.cmcdragonkai ];
  };
}
