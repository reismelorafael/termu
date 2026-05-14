# bootstrap_src

Código ASM em trilha de promoção (compilável em isolamento), ainda **fora** do CMake/Gradle.

## Arquivos
- `bootstrap_arm64_adaptive.S`: versão limpa inicial derivada da referência `bootstrap_ref/bootstrap_arm64_adaptive.s.txt`.

## Validação isolada
```bash
clang --target=aarch64-linux-android21 -c app/src/main/cpp/lowlevel/bootstrap_src/bootstrap_arm64_adaptive.S -o /tmp/bootstrap_arm64_adaptive.o
```

Se falhar, corrigir no próprio `bootstrap_src` sem alterar a referência congelada em `bootstrap_ref`.
