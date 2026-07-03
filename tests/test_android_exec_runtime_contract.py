from pathlib import Path


def test_target_sdk_preserves_prefix_binary_execution_contract():
    props = Path("gradle.properties").read_text(encoding="utf-8")
    values = {}
    for line in props.splitlines():
        line = line.strip()
        if not line or line.startswith("#") or "=" not in line:
            continue
        key, value = line.split("=", 1)
        values[key.strip()] = value.strip()

    target_sdk = int(values["targetSdkVersion"])
    compile_sdk = int(values["compileSdkVersion"])

    assert target_sdk <= 28, (
        "Termux-style execution of package/bootstrap binaries from the app private "
        "PREFIX requires targetSdkVersion <= 28. Keep compileSdkVersion modern "
        "for build/API compatibility, but do not raise targetSdkVersion without "
        "a verified alternate executable storage strategy."
    )
    assert compile_sdk >= 35
