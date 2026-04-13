---
title: Integrando meu AVR com o Home Assistant
date: 2026-03-30T17:53:21-03:00
description: Mostro como criei uma CLI em Go para controlar a Zone 2 via WebSocket e integrar meu AVR ao Home Assistant com um switch command_line.
tags: [homeassistant, go, websocket, smarthome]
cover_image: https://dev-to-uploads.s3.amazonaws.com/uploads/articles/ohklh9cd0rr9wea7v2z3.png
---

## Resumo
Como criei uma CLI em Go para controlar a Zone 2 via WebSocket e integrar meu AVR (também chamado de "receiver" ou "home theater") ao Home Assistant com um interruptor (switch) `command_line` confiável.

Eu estava cansada de fuçar menus minúsculos no receiver só para ligar e desligar a Zone 2.

Então escrevi uma CLI pequena em Go (`zone2`) que conversa direto com o AVR por WebSocket e depois conectei no Home Assistant como um switch `command_line`.

Se você tem um receiver Arcam / AudioControl / JBL Synthesis com API WebSocket de setup exposta na porta `50001`, esse caminho é bem direto e rápido.

> [Código-fonte](https://github.com/moniquelive/zone2)

## Por que comecei por uma CLI

Em vez de partir direto para uma integração customizada do Home Assistant, eu queria primeiro um binário simples que:

- rode em qualquer lugar
- seja fácil de testar no terminal
- retorne `on` / `off` em texto puro para o parsing das automações

Isso me deu uma base estável antes de mexer com dashboards e YAML.

## Como a comunicação com o AVR funciona

A ferramenta conecta em:

- `ws://<IP_DO_AVR>:50001`

Ela envia frames binários do protocolo da Zone 2 (`command 0x2F`) e depois interpreta as respostas binárias do AVR.

Formato dos frames (simplificado):

```text
request:  21 01 <command> <len> <payload...> 0D
response: 21 01 <command> <status> <len> <payload...> 0D
```

Para leitura, ela consulta o modelo da Zone 2 e inspeciona o segundo byte (`model[1]`) como estado de energia:

- `0` => off
- `1` => on

Para escrita (`on`, `off`, `toggle`), ela altera esse byte e envia o modelo completo de volta.

## Ajustes de confiabilidade que fizeram diferença

A parte difícil não foi "enviar comando"; foi deixar o comportamento confiável o suficiente para automações.

Adicionei algumas proteções:

1. **Separação de frames**
   - O receiver pode mandar múltiplos frames de protocolo em uma única mensagem WebSocket.
   - O cliente extrai frames válidos por header/tamanho/terminador e escolhe o comando certo.

2. **Parsing estrito da resposta**
   - Valida framing, ID do comando, terminador e tamanho de payload declarado.
   - Rejeita frame malformado cedo.

3. **Retry para estados transitórios**
   - Consulta da Zone 2 com retry de até 5 tentativas.
   - Trata status temporário `0x85` aguardando um pouco e tentando de novo.

4. **Loop de verificação pós-escrita**
   - Depois de escrever, consulta novamente até o estado desejado "grudar" (padrão `20` tentativas).
   - Evita falso positivo quando chega ACK de escrita, mas o estado não mudou de fato.

Foi isso que deixou tudo utilizável no Home Assistant sem aqueles momentos de "acho que foi".

## Uso da CLI

```bash
./zone2-macos-arm64 -host SEU_IP_DO_AVR -mode status
./zone2-macos-arm64 -host SEU_IP_DO_AVR -mode on
./zone2-macos-arm64 -host SEU_IP_DO_AVR -mode off
./zone2-macos-arm64 -host SEU_IP_DO_AVR -mode toggle
```

Flags:

- `-host` (obrigatória)
- `-mode` (`on|off|toggle|status`)
- `-timeout` (padrão `4s`)
- `-verify` (padrão `20`, usado nas escritas)
- `-verbose` (mostra frames TX/RX brutos)

## Integração com Home Assistant

Eu faço cross-compile de um binário Linux ARM64 para o HA OS (Raspberry Pi 5), copio para `/config/bin` e exponho via `command_line`:

```yaml
command_line:
  - switch:
      name: AVR Zone 2
      unique_id: avr_zone2
      command_on: "/config/bin/zone2 -host SEU_IP_DO_AVR -mode on -timeout 4s -verify 20"
      command_off: "/config/bin/zone2 -host SEU_IP_DO_AVR -mode off -timeout 4s -verify 20"
      command_state: "/config/bin/zone2 -host SEU_IP_DO_AVR -mode status -timeout 4s"
      value_template: "{{ value | trim | lower == 'on' }}"
      scan_interval: 10
```

Como a CLI imprime exatamente `on` ou `off`, o `value_template` fica simples e confiável.

## Build + release

O repositório inclui:

- alvos no Makefile para Linux ARM64 + macOS
- CI (`go test`, `go vet`)
- workflow de GitHub Release por tag anexando os binários compilados

Isso facilitou testar localmente e fazer deploy de forma repetível.

## Considerações finais

Foi um projetinho pequeno, mas com um lembrete valioso: em automação residencial, **verificação de estado** é mais importante do que "comando enviado com sucesso".

Uma CLI minúscula, determinística e com saída clara já resolve muito para plugar hardware sem suporte oficial no Home Assistant.

Se eu evoluir isso depois, a ideia é adicionar controles de input/volume e talvez empacotar uma integração completa para HA quando o protocolo estiver mais maduro.

_

= M =
