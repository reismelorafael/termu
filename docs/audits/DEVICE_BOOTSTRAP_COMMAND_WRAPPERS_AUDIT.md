# DEVICE_BOOTSTRAP_COMMAND_WRAPPERS_AUDIT

## Escopo

Auditoria operacional motivada por teste real em device Android no prefixo:

```text
/data/data/com.termux.rafacodephi/files/usr
/data/data/com.termux.rafacodephi/files/home
```

O objetivo é rastrear a diferença entre o contrato estrutural do bootstrap e o comportamento observado no terminal RAFCODEPHI.

## Evidência observada em device

Estado inicial reportado:

```text
ls: inaccessible or not found
apk: inaccessible or not found
install: inaccessible or not found
pkg[22]: cat: inaccessible or not found
PATH=/data/data/com.termux.rafacodephi/files/usr/bin
```

Sinais positivos encontrados no mesmo device:

```text
/system/bin/toybox existe e executa
/system/bin/cat existe e executa
/system/bin/ls existe e executa
$PREFIX/bin/busybox existe e executa
$PREFIX/bin/sh existe e executa
$PREFIX/bin/pkg existe e executa
```

Teste de compatibilidade manual:

```text
cat --help = OK
ls $PREFIX/bin = OK
pkg help = OK
clear = busybox bridge requires an applet name
```

Interpretação: o `busybox` embarcado é uma bridge que exige applet explícito. Portanto, `ln -s busybox ls` não é contrato suficiente. O runtime precisa de wrappers reais que chamem `busybox <applet> "$@"`.

## Falha-raiz

O bootstrap declarava `BOOTSTRAP_COMMAND_WRAPPERS_READY=1`, mas o pacote installável não garantia entradas executáveis como:

```text
bin/cat
bin/ls
bin/clear
bin/grep
```

Com isso, o shell abria, mas comandos básicos não existiam no `PATH` interno. O `pkg` também quebrava porque seu próprio texto de ajuda depende de `cat` no ambiente.

## Correção aplicada nesta auditoria

1. `scripts/build_rafaelia_bootstraps.sh` agora gera wrappers explícitos para applets essenciais.
2. `scripts/bootstrap_zip_builder.c` agora empacota esses wrappers dentro dos zips `rewritten-bootstrap-*.zip`.
3. O hotfix `rafcodephi-compat-hotfix` passa a validar `cat`, `ls`, `clear` e `grep`.
4. O CI passa a inspecionar que os wrappers existem e têm bit executável.
5. Novos testes travam a diferença entre busybox bridge e wrapper real.

## Contrato mínimo pós-correção

O beta só pode afirmar bootstrap mínimo vivo se, em prefixo limpo, existir:

```text
bin/sh
bin/pkg
bin/busybox
bin/cat
bin/ls
bin/clear
bin/grep
bin/sed
bin/awk
bin/head
bin/tail
bin/wc
```

E se os comandos abaixo passarem no device:

```sh
cat --help
ls "$HOME"
clear
grep x /dev/null
pkg help
```

## Limite honesto

Esta auditoria **não** prova apt real. Ela separa duas camadas:

| Camada | Estado |
|---|---|
| shell mínimo + wrappers | corrigido estruturalmente |
| busybox bridge por applet explícito | corrigido estruturalmente |
| `pkg help` sem quebrar por falta de `cat` | corrigido estruturalmente |
| apt/apt-get backend real | TOKEN_VAZIO até payload core real |
| dpkg/libapt/proot real | TOKEN_VAZIO até payload core real e smoke em device |

## Próximo teste obrigatório em device

Depois de gerar novo APK beta:

```sh
export PREFIX=/data/data/com.termux.rafacodephi/files/usr
export HOME=/data/data/com.termux.rafacodephi/files/home
export PATH="$PREFIX/bin:/system/bin:/system/xbin:/apex/com.android.runtime/bin"

cat --help
ls "$HOME"
clear
grep x /dev/null
pkg help
apt
```

Resultado esperado atual:

```text
cat/ls/clear/grep/pkg help = OK
apt = bridge informando backend real ausente
```

## Veredito

F_ok: a falha observada no device foi rastreada até a ausência de wrappers explícitos.

F_gap: o payload core de pacotes reais ainda precisa ser construído, validado e promovido separadamente.

F_next: impedir promoção de beta quando `bin/cat`, `bin/ls`, `bin/clear`, `bin/grep` e demais wrappers mínimos não estiverem presentes no zip de bootstrap.
