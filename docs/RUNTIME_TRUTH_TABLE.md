# RUNTIME_TRUTH_TABLE — mapa operacional RAFCODEΦ

| Recurso | Estado real | Evidência | Lacuna |
|---|---|---|---|
| APK build | PROVADO | Gradle/CI; `scripts/build_apk_matrix.sh` | — |
| release assinado | PROVADO | `./gradlew verifyReleaseContract` | segredo oficial no ambiente |
| bootstrap instala | PARCIAL | `TermuxInstaller` com staging/rollback | teste real em device |
| `sh` | PARCIAL | bootstrap/wrapper | validar no device |
| `pkg` | TOKEN_VAZIO | script bridge bootstrap | backend real |
| `apt` | TOKEN_VAZIO | script bridge bootstrap | backend real |
| `apt-get` | TOKEN_VAZIO | script bridge bootstrap | backend real |
| `dpkg` | TOKEN_VAZIO | requisito de payload core | binário real |
| `libapt` | TOKEN_VAZIO | requisito de payload core | bibliotecas reais |
| `busybox` | PARCIAL | wrapper/delegação para toybox/toolbox quando possível | busybox real ou substituto consistente |
| `proot` | TOKEN_VAZIO | bridge/wrapper | `proot.real` ou equivalente |
| certificados | TOKEN_VAZIO | requisito de payload core | CA bundle real |
| DNS/network básico | TOKEN_VAZIO | requisito de payload core | resolver funcional e teste rede |
| repositório configurado | TOKEN_VAZIO | requisito de payload core | `sources.list`/config real |
| `pkg update` | FUTURO | contrato definido | teste real bloqueante |
| `pkg install` | FUTURO | contrato definido | instalar nano/python/git |
| RAFAELIA JNI | PROVADO ESTRUTURAL | C/JNI | benchmark |
| CTI | PROVADO ESTRUTURAL | C scanner | teste com arquivos grandes |
| ZIPRAF | PROVADO ESTRUTURAL | manifesto | documentação clara; não é compressão |
| VCPU | PROVADO ESTRUTURAL | C state machine | falta VM completa |
| device smoke | PARCIAL | `scripts/device_runtime_smoke.sh` | `DEVICE_SMOKE_REQUIRED=true` em CI real |

## Frase canônica do bootstrap

O bootstrap atual fornece uma base mínima guardada para instalação e diagnóstico, mas ainda não equivale a uma distribuição Termux completa com backend apt real.
