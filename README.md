# ASM Invaders

Projeto de jogo estilo “Space Invaders” feito em Assembly para o Processador-ICMC. A ideia é usar um “Text Drawer” que desenha caracteres em uma tela 30×40 e, quando dá, aplicar cor por célula usando um valor 16 bits no `OUTCHAR`.

Foi feito para aprender:
- Como desenhar e posicionar caracteres na tela
- Como ler teclado e mover algo no mapa
- Como fazer um loop de jogo simples (spawn, mover, checar colisão)
- Como usar um gerador pseudo-aleatório e uma HUD de pontuação
- Como aplicar cor em cima do ASCII (quando o simulador suporta)

## Como funciona a tela

- A tela é uma grade de 30 linhas × 40 colunas (total 1200 células).
- Cada célula é um índice de 0 a 1199.
- Para ir para a próxima linha: some 40 na posição.
- A arena tem paredes nas colunas 10 (esquerda) e 30 (direita).
- A nave ocupa 1 célula; cada inimigo ocupa 3 células seguidas na horizontal.

## Cores

A gente soma um “offset de cor” em cima do código ASCII do caractere:

- Bits 15..13: Red (0..7)
- Bits 12..10: Green (0..7)
- Bits 9..8:   Blue (0..3)
- Bits 7..0:   ASCII

Fórmula do offset:
```
offset = (R << 13) | (G << 10) | (B << 8)
OUTCHAR(ASCII + offset, pos)
```

Exemplos úteis:
- Vermelho: R=7,G=0,B=0 → 57344
- Amarelo:  R=7,G=7,B=0 → 64512
- Azul claro: R=0,G=7,B=1 → 3584
- Verde: R=0,G=7,B=0 → 7168

No nosso jogo:
- Nave: azul claro
- Inimigos: vermelho
- Pontuação (HUD): amarelo
- Paredes: deixamos padrão (branco), mas dá para colorir fácil

## Controles

- Na tela inicial, aperte `SPACE` para começar.
- Movimento: `W` (cima), `A` (esquerda), `S` (baixo), `D` (direita)
- Limites:
  - Paredes: colunas 10 e 30 (usando `pos % 40`)
  - Topo da arena: ~320
  - Piso da arena: ~1050
  - Chão p/ matar inimigo: 1080

## O que rola no jogo

- Aparecem até 3 inimigos simultâneos (slots `r3`, `r5`, `r4`).
- Cada inimigo é um bloco de 3 colunas e vai caindo (somando 40).
- Chance de spawn: `random % 15 == 0`.
- Se um inimigo passar do chão, ele é removido e +1 ponto.
- A cada ponto, o jogo fica um pouco mais rápido (diminui `game_speed` até no mínimo 200).
- Se a nave encostar em qualquer parte de um inimigo (pos, pos+1, pos+2), desenha uma explosão e vai para “Game Over”.
- Na tela de “Game Over” aparece o score final e volta para o início.

## Estrutura do código (as funções principais)

- `print_title_screen`: imprime 30 linhas do título (sem cor).
- `main`: reseta score/velocidade, espera `SPACE`, limpa e desenha a arena, e entra no loop.
- `ship`: lê WASD, atualiza posição da nave e desenha a nave azul.
- `spawn_enemy`: decide se spawna e usa o primeiro slot livre (r3, r5, r4).
- `move_enemies`: apaga, desce, elimina se passar do chão, redesenha em vermelho.
- `collide_test`: checa colisão da nave com os blocos 3×1 de cada inimigo.
- `collide`: desenha a explosão e chama `game_over_screen`.
- `print_cage`: desenha paredes e base.
- `game_over_screen`: limpa a tela, imprime o “Game Over” e o score final, depois volta para o início.
- `print_score`: imprime a pontuação atual em amarelo (3 dígitos) na HUD.
- `print_string_pos`: imprime uma string terminada em 0 (sem cor).
- `clear_screen`: zera as 1200 posições da tela.
- `print_score_final`: imprime 4 dígitos na tela final.
- `random`: gerador pseudo-aleatório (LCG) com uma “bagunçadinha” extra.
- `get_random_pos`: converte o aleatório em uma posição boa para spawn.
- `delay`: controla a velocidade com dois laços.
- `limpa_score`: zera a pontuação.
- `add_score`: +1 ponto, HUD, e acelera o jogo até um limite.

## Registradores e variáveis que importam

- `r1`: posição da nave (índice na tela)
- `r3`, `r5`, `r4`: slots de inimigos (0 = vazio). Cada um ocupa 3 colunas (pos, pos+1, pos+2).
- `r7`: a gente usa bastante para teclado, temporários e o número aleatório.
- `score`: pontuação atual
- `game_speed`: controla quantas “esperas” o jogo faz no delay
- `random_a`, `random_c`, `random_m`, `random_x`: parâmetros e estado do random

## Como rodar

1. Clone o repositório Processador‑ICMC (contém o montador e o simulador).
2. Copie `jogo.asm` e `jogo.mif` para a pasta do montador/simulador (ou para o diretório indicado no Manual do Processador‑ICMC).
3. Monte o `.asm` com o montador(ex: ./montador Hello4.asm Hello4.mif). Consulte o Manual do Processador‑ICMC para o comando correto caso apresente erro.  
4. Execute o simulador (ex: ./simulador jogo.mif charmap.mif). Consulte o Manual do Processador‑ICMC para o comando correto caso apresente erro.  
5. Na tela inicial do jogo, pressione `SPACE` para começar.


## Constantes que aparecem no código

- 40: largura da linha (pular uma linha e também `pos % 40` para coluna)
- 1200: total de células (30×40)
- 320: topo da arena (não deixa passar)
- 1050: piso da arena (não deixa passar)
- 1080: chão para matar inimigo (amarra remoção)
- Slots de inimigos: `r3`, `r5`, `r4`

## Créditos

- Código do jogo: Caio Mendes Laprega, Larry Felipe Silva Gonçalves, Yan Barbosa Servilha
- Base: [Processador-ICMC](https://github.com/simoesusp/Processador-ICMC)

> Observação: A gente comentou bastante o `.asm` para ficar didático. Qualquer coisa, vale olhar as funções com calma que tem explicação do que cada uma está fazendo.
