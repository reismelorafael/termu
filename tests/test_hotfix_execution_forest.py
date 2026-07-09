from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
FOREST = ROOT / 'docs/HOTFIX_EXECUTION_FOREST.md'
RUNBOOK = ROOT / 'docs/ENGINEERING_RUNBOOK_RAFCODEPHI.md'
TRUTH_TABLE = ROOT / 'docs/RUNTIME_TRUTH_TABLE.md'


def test_hotfix_forest_exists_and_preserves_epistemic_states():
    text = FOREST.read_text(encoding='utf-8')
    for token in ['PROVADO', 'PROVADO ESTRUTURAL', 'PARCIAL', 'TOKEN_VAZIO', 'EXPERIMENTAL', 'FUTURO']:
        assert token in text
    assert 'nada sai de `TOKEN_VAZIO` para `PROVADO` sem prova funcional em dispositivo Android real' in text


def test_hotfix_forest_tracks_core_runtime_blockers():
    text = FOREST.read_text(encoding='utf-8')
    for token in [
        'LEGACY_PREFIX_BINARY_RISK',
        'pkg update',
        'pkg install nano',
        'pkg install python',
        'pkg install git',
        'DEVICE_SMOKE_REQUIRED=true',
        'processos/zumbis/orfãos',
        'p50/p95/p99',
        'RAFAELIA deterministic VCPU state kernel',
    ]:
        assert token in text


def test_runbook_links_to_hotfix_forest_and_keeps_promotion_guard():
    text = RUNBOOK.read_text(encoding='utf-8')
    assert 'docs/HOTFIX_EXECUTION_FOREST.md' in text
    assert 'vetor → lacuna → hotfix → prova mínima → artefato → promoção epistêmica' in text
    assert 'Nada deve sair de `TOKEN_VAZIO` para `PROVADO` sem device real' in text


def test_truth_table_still_keeps_package_stack_unproved():
    text = TRUTH_TABLE.read_text(encoding='utf-8')
    for token in ['`pkg` | TOKEN_VAZIO', '`apt` | TOKEN_VAZIO', '`apt-get` | TOKEN_VAZIO', '`dpkg` | TOKEN_VAZIO', '`libapt` | TOKEN_VAZIO', '`proot` | TOKEN_VAZIO']:
        assert token in text
