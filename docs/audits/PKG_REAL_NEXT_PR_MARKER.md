# PKG_REAL_NEXT_PR_MARKER

Este marcador separa o PR de wrappers mínimos do próximo PR de promoção do `pkg` real.

- PR anterior: corrige `cat/ls/clear/grep/pkg help`.
- PR atual: cria smoke e contrato para promover `pkg update/install` somente com device real.

Não promover `pkg` para PROVADO sem `DEVICE_REAL_PKG_VALIDATED`.
