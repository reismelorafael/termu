from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def read(path: str) -> str:
    return (ROOT / path).read_text(encoding="utf-8")


def test_terminal_service_execution_paths_are_documented() -> None:
    service = read("app/src/main/java/com/termux/app/TermuxService.java")
    doc = read("docs/audits/TERMINAL_SERVICE_BOOTSTRAP_GAP.md")

    for token in (
        "ACTION_SERVICE_EXECUTE",
        "actionServiceExecute",
        "executeTermuxTaskCommand",
        "executeTermuxSessionCommand",
        "createTermuxTask",
        "createTermuxSession",
        "AppShell.execute",
        "TermuxSession.execute",
    ):
        assert token in service

    assert "SERVICE_PLUGIN_EXECUTION_BOOTSTRAP_GUARD = TOKEN_VAZIO_CODE_PATCH" in doc
    assert "NORMAL_ACTIVITY_FIRST_SESSION = GUARDED" in doc
    assert "FAILSAFE_SESSION_COMPATIBILITY = MUST_PRESERVE" in doc
    assert "DEVICE_RUNTIME_SMOKE = PENDING" in doc


def test_normal_activity_startup_chain_remains_guarded() -> None:
    activity = read("app/src/main/java/com/termux/app/TermuxActivity.java")

    permission_callback = activity.index("public void onRequestPermissionsResult")
    permission_storage = activity.index("requestStoragePermission(true)", permission_callback)
    permission_service = activity.index("startAndBindTermuxServiceOrFail()", permission_storage)
    assert permission_storage < permission_service

    service_connected = activity.index("public void onServiceConnected")
    bootstrap_call = activity.index("TermuxInstaller.setupBootstrapIfNeeded", service_connected)
    initial_session = activity.index("createInitialSession(intent)", bootstrap_call)
    assert bootstrap_call < initial_session
