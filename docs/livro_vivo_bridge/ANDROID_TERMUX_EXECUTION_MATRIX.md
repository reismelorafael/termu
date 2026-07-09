# ANDROID_TERMUX_EXECUTION_MATRIX — Matriz de Execução Android/Termux

> Repositório: `termux-app-rafacodephi`  
> Ponte: Livro Vivo RAFAELIA  
> Status: `RESULTADO_COMPUTACIONAL` quando preenchido com execução real  
> Regra: execução sem ambiente declarado é boato técnico

## 1. Parábola da porta, da dobradiça e do vento

O ferreiro fez uma chave perfeita.

No primeiro dia, a porta abriu.
No segundo, a porta rangeu.
No terceiro, a porta travou.
No quarto, o vento empurrou a folha.
No quinto, a dobradiça inchou com chuva.

O ferreiro disse:

— A chave falhou.

O mestre respondeu:

— Talvez. Mas tu registraste a porta, a dobradiça, o vento e a mão que girou a chave?

O ferreiro ficou em silêncio.

Então o mestre escreveu:

```text
em Android, até o vento entra no teste
```

Esta matriz existe para registrar o vento.

---

## 2. Invariante

```text
dispositivo → Android/API → ABI/CPU → permissões → comando → saída → falha → artefato
```

Forma compacta:

```math
Inv(Termux)=Device \rightarrow Environment \rightarrow Command \rightarrow Output \rightarrow Artifact
```

---

## 3. Ficha mínima por aparelho

```yaml
device_name: "ex: Motorola moto e(7) power"
model: "ex: moto e(7) power"
android_version: "ex: Android 10"
api_level: "ex: 29"
kernel: "ex: 4.9.x"
abi: "armeabi-v7a|arm64-v8a"
cpu: "ex: ARMv7 rev4, NEON"
ram_total: "ex: 1781 MB"
storage_free: "ex: 2 GB"
root: false
bootloader: "locked|unlocked|unknown"
app_package: "com.termux.rafacodephi"
app_version: "ex: 0.118.0-rafacodephi"
prefix: "/data/data/com.termux.rafacodephi/files/usr"
home: "/data/data/com.termux.rafacodephi/files/home"
phantom_process_mitigation: "yes|no|unknown"
```

---

## 4. Ficha mínima por execução

```yaml
run_id: "YYYYMMDD-HHMM-device-test"
device_name: ""
command: ""
working_directory: ""
expected_output: ""
actual_output: ""
exit_code: ""
artifacts:
  - "path/to/artifact"
status: PASS|FAIL|PARTIAL|TOKEN_VAZIO
failure_mode: "permission|missing_binary|timeout|abi|storage|phantom_killer|unknown"
notes: ""
```

---

## 5. Matriz inicial de camadas

| Camada | Pergunta | Exemplo de evidência |
|---|---|---|
| App | qual APK/pacote roda? | package name, versionCode, versionName |
| Android | qual sistema governa? | Android version, API, kernel |
| ABI | qual arquitetura executa? | armeabi-v7a, arm64-v8a |
| Shell | qual `/bin/sh` existe? | caminho e permissão |
| Bootstrap | existe busybox/pkg/dpkg? | comando e saída |
| Storage | há acesso a armazenamento? | `termux-setup-storage` ou equivalente |
| Permissões | o Android permite? | logs e status |
| Processo | phantom killer interfere? | foreground service, battery exempt |
| Build | compila? | comando, exit code |
| Artefato | gerou arquivo? | path e checksum |

---

## 6. Smoke tests mínimos

### 6.1 Shell

```sh
printf 'RAFAELIA_TERMUX_SMOKE\n'
```

Esperado:

```text
RAFAELIA_TERMUX_SMOKE
```

### 6.2 Ambiente

```sh
uname -a || true
getprop ro.build.version.release || true
getprop ro.product.model || true
```

### 6.3 Escrita local

```sh
mkdir -p "$HOME/rafaelia_smoke"
printf 'ok\n' > "$HOME/rafaelia_smoke/out.txt"
cat "$HOME/rafaelia_smoke/out.txt"
```

### 6.4 Binários básicos

```sh
command -v sh || true
command -v busybox || true
command -v pkg || true
command -v dpkg || true
command -v clang || true
```

---

## 7. Falhas conhecidas a classificar

| Falha | Selo | Ação |
|---|---|---|
| `Permission denied` em shell | `FAIL` | verificar chmod, mount, SELinux/app sandbox |
| ausência de `dpkg` | `PARTIAL` | marcar package backend incompleto |
| ausência de `ls/head/find` | `PARTIAL` | depender de busybox ou bootstrap real |
| phantom process killer | `FAIL/PARTIAL` | foreground service + battery exempt |
| storage baixo | `FAIL/PARTIAL` | liberar espaço ou reduzir teste |
| ABI errada | `FAIL` | separar ARM32/ARM64 |

---

## 8. Artefatos recomendados

```text
artifacts/android_termux/device_info.json
artifacts/android_termux/smoke_shell.txt
artifacts/android_termux/binaries.txt
artifacts/android_termux/build.log
artifacts/android_termux/failure_modes.md
```

---

## 9. Status epistemológico

| Resultado | Selo correto |
|---|---|
| smoke test rodou uma vez | `RESULTADO_COMPUTACIONAL` |
| build passou em um aparelho | `RESULTADO_COMPUTACIONAL` |
| build passou em matriz de aparelhos | `RESULTADO_COMPUTACIONAL` mais forte |
| hipótese de estabilidade | `HIPOTESE_AUTORAL` |
| comando não testado | `TOKEN_VAZIO` |

---

## 10. Parábola final — O chão que responde

O discípulo desenhou uma máquina no papel.

O mestre perguntou:

— Ela roda?

— No meu pensamento, sim.

O mestre colocou o papel no chão e disse:

— Pensamento acende a máquina. Chão revela se ela caminha.

E escreveu:

```text
comando copiável → saída observável → artefato guardado
```

---

## 11. Retroalimentar[3]

- **F_ok:** a matriz separa aparelho, Android, ABI, shell, bootstrap, falha e artefato.
- **F_gap:** falta preencher com execuções reais por dispositivo.
- **F_next:** criar `artifacts/android_termux/device_info.json` e primeiro smoke test versionado.
