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
        "ensureBootstrapReadyForExecution",
        "failExecutionCommandOnBootstrapNotReady",
    ):
        assert token in service

    assert "SERVICE_PLUGIN_EXECUTION_BOOTSTRAP_GUARD = IMPLEMENTED" in doc
    assert "NORMAL_ACTIVITY_FIRST_SESSION = GUARDED" in doc
    assert "FAILSAFE_SESSION_COMPATIBILITY = MUST_PRESERVE" in doc
    assert "DEVICE_RUNTIME_SMOKE = PENDING" in doc


def test_service_execution_bootstrap_guard_runs_before_executor_calls() -> None:
    service = read("app/src/main/java/com/termux/app/TermuxService.java")

    task_guard = service.index('ensureBootstrapReadyForExecution(executionCommand, "TermuxTask")')
    task_exec = service.index("AppShell.execute(")
    assert task_guard < task_exec

    session_guard = service.index('ensureBootstrapReadyForExecution(executionCommand, "TermuxSession")')
    session_exec = service.index("TermuxSession.execute(")
    assert session_guard < session_exec


def test_bootstrap_guard_skips_failsafe_and_fails_cleanly_otherwise() -> None:
    service = read("app/src/main/java/com/termux/app/TermuxService.java")

    guard_start = service.index("private Error ensureBootstrapReadyForExecution")
    guard_end = service.index("\n    }", guard_start)
    guard_body = service[guard_start:guard_end]

    assert "if (executionCommand.isFailsafe)" in guard_body
    assert "TermuxQualityManager.checkBootstrapComplete()" in guard_body

    fail_start = service.index("private void failExecutionCommandOnBootstrapNotReady")
    fail_end = service.index("\n    }", fail_start)
    fail_body = service[fail_start:fail_end]

    assert "executionCommand.setStateFailed(bootstrapError)" in fail_body
    assert "TermuxPluginUtils.processPluginExecutionCommandError" in fail_body
    assert "removePendingPluginExecutionCommand(executionCommand)" in fail_body


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
