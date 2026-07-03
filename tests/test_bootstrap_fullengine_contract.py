from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
BUILDER = ROOT / "scripts/bootstrap_zip_builder.c"


def test_bootstrap_builder_declares_fullengine_contract():
    source = BUILDER.read_text(encoding="utf-8")
    for token in (
        "BOOTSTRAP_FULLENGINE_READY=1",
        "BOOTSTRAP_PATHS_VALIDATED=1",
        "BOOTSTRAP_PERMISSIONS_DECLARED=1",
        "BOOTSTRAP_COMMAND_WRAPPERS_READY=1",
        "FULLENGINE_READY=1",
        "COMMAND_WRAPPERS_READY=1",
        "bin/rafcodephi-compat-hotfix",
        "bin/apt",
        "bin/apt-get",
    ):
        assert token in source


def test_bootstrap_builder_rejects_unsafe_paths_and_declares_modes():
    source = BUILDER.read_text(encoding="utf-8")
    assert "valid_zip_path" in source
    assert "p[0]=='/'" in source
    assert "strstr(p,\"..\")" in source
    assert "uint32_t mode" in source
    assert "0700" in source
    assert "0600" in source
    assert "external_attr" not in source.lower()
    assert "le32(c+38" in source
