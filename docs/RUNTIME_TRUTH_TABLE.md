# RUNTIME_TRUTH_TABLE — mapa operacional RAFCODEΦ

| Recurso | Estado real | Evidência | Lacuna |
|---|---|---|---|
| APK build | PROVADO | Gradle/CI; `scripts/build_apk_matrix.sh` | — |
| release assinado | PROVADO | `./gradlew verifyReleaseContract` | segredo oficial no ambiente |
| bootstrap instala | PARCIAL | `TermuxInstaller` com staging/rollback | teste real em device |
| `sh` | PARCIAL | bootstrap/wrapper | validar no device |
| `pkg` | TOKEN_VAZIO | script bridge bootstrap | backend real |
| `apt` | TOKEN_VAZIO | gerador ARM real criado (`scripts/build_real_arm_bootstrap_core.py`), sem device `pkg update` ainda | backend real validado em device |
| `apt-get` | TOKEN_VAZIO | gerador ARM real criado (`scripts/build_real_arm_bootstrap_core.py`), sem device `pkg update` ainda | backend real validado em device |
| `dpkg` | TOKEN_VAZIO | gerador ARM real criado (`scripts/build_real_arm_bootstrap_core.py`), sem device package install ainda | binário real validado em device |
| `libapt` | TOKEN_VAZIO | dependency closure for `apt` inclui bibliotecas libapt, sem dynamic-link em device ainda | teste dynamic-link em device |
| `busybox` | PARCIAL | wrapper/delegação para toybox/toolbox quando possível | busybox real ou substituto consistente |
| `proot` | TOKEN_VAZIO | generator renames real Termux `proot` to `bin/proot.real` and emits `bin/proot` shim, sem device ainda | `proot --version` on device |
| certificados | TOKEN_VAZIO | generator includes `ca-certificates` package, sem TLS em device ainda | TLS/package update on device |
| DNS/network básico | TOKEN_VAZIO | generator writes guarded `etc/resolv.conf`, sem rede em device ainda | network test on device |
| repositório configurado | TOKEN_VAZIO | generator writes `etc/apt/sources.list` for Termux main, sem `apt update` em device ainda | `apt update` on device |
| `pkg update` | FUTURO | contrato definido | teste real bloqueante |
| `pkg install` | FUTURO | contrato definido | instalar nano/python/git |
| RAFAELIA JNI | PROVADO ESTRUTURAL | C/JNI | benchmark |
| CTI | PROVADO ESTRUTURAL | C scanner | teste com arquivos grandes |
| ZIPRAF | PROVADO ESTRUTURAL | manifesto | documentação clara; não é compressão |
| VCPU | PROVADO ESTRUTURAL | C state machine | falta VM completa |
| device smoke | PARCIAL | `scripts/device_runtime_smoke.sh` | `DEVICE_SMOKE_REQUIRED=true` em CI real |

## Frase canônica do bootstrap

O bootstrap atual fornece uma base mínima guardada para instalação e diagnóstico, mas ainda não equivale a uma distribuição Termux completa com backend apt real.
