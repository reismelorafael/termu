# PKG_REAL_COMPARE_STATUS

A branch deste PR parte do merge-base anterior ao merge dos wrappers e está `behind` do merge commit em `master`, mas contém apenas o escopo de promoção do `pkg` real como diferença operacional nova.

Comparar antes do merge:

```bash
git fetch origin
git log --oneline origin/master..origin/audit/bootstrap-command-wrapper-contract
```

O escopo novo esperado inclui:

- `scripts/device_pkg_smoke.sh`
- `docs/audits/REAL_PKG_PROMOTION_CONTRACT.md`
- `tests/test_device_pkg_smoke_contract.py`
- `tests/test_real_pkg_promotion_contract.py`
- workflow `validate-real-pkg-promotion-contract.yml`

Sem `DEVICE_REAL_PKG_VALIDATED`, `pkg update/install` permanece `TOKEN_VAZIO`.
