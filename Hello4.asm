; ==============================================================================
;                              ASM INVADERS
; ==============================================================================
; Autores:
; Caio Mendes Laprega
; Larry Felipe Silva Gonçalves
; Yan Barbosa Servilha
; ==============================================================================

; Pula a declaração de dados para ir direto ao início da execução
jmp print_title_screen

; ==============================================================================
;                         DECLARAÇÃO DE VARIÁVEIS
; ==============================================================================
random_a: var #1    ; Parâmetro 'a' para o gerador de números aleatórios
random_c: var #1    ; Parâmetro 'c' para o gerador
random_m: var #1    ; Parâmetro 'm' (módulo) para o gerador
random_x: var #1    ; Semente atual (seed) do aleatório
score: var #1       ; Armazena a pontuação atual
game_speed: var #1  ; Controla o tempo do delay (dificuldade)

; --- Inicialização de Variáveis Estáticas ---
; Valores escolhidos para o Algoritmo Linear Congruente (RNG)
static random_a+#0, #25173 
static random_c+#0, #13849
static random_m+#0, #65535
static random_x+#0, #7 
static score+#0, #0
static game_speed + #0, #3000 ; Começa com delay de 3000 ciclos


; ==============================================================================
;                         STRINGS E TELAS (DADOS)
; ==============================================================================

; --- TELA INICIAL ---
; Desenho em ASCII art para o menu principal
inicialLinha0  : string "                                        "
inicialLinha1  : string "    |      ###   ###  #   #        |    "
inicialLinha2  : string "    |     #   # #     ## ##        |    "
inicialLinha3  : string "    |     #####  ###  # # #        |    "
inicialLinha4  : string "    |     #   #     # #   #        |    "
inicialLinha5  : string "    |     #   #  ###  #   #        |    "
inicialLinha6  : string "    |                              |    "
inicialLinha7  : string " ###|#  # #   #  ###  ###  ### ### |### "
inicialLinha8  : string "  # |## # #   # #   # #  # #   #  #|#   "
inicialLinha9  : string "  # |# ## #   # ##### #  # ### ### | #  "
inicialLinha10 : string "  # |#  #  # #  #   # #  # #   # # |  # "
inicialLinha11 : string " ###|#  #   #   #   # ###  ### # # |### "
inicialLinha12 : string "    |                              |    "
inicialLinha13 : string "    |                              |    "
inicialLinha14 : string "    |             #   #            |    "
inicialLinha15 : string "    |            #######           |    "
inicialLinha16 : string "    |            # ### #           |    "
inicialLinha17 : string "    |           # #   # #          |    "
inicialLinha18 : string "    |                              |    "
inicialLinha19 : string "    |                              |    "
inicialLinha20 : string "    |                              |    "
inicialLinha21 : string "    |  APERTE SPACE PARA INICIAR   |    "
inicialLinha22 : string "    |                              |    "
inicialLinha23 : string "    |                              |    "
inicialLinha24 : string "    |                              |    "
inicialLinha25 : string "    |                              |    "
inicialLinha26 : string "    | Use W A S D pra mover a Nave |    "
inicialLinha27 : string "   _|______________________________|_   "
inicialLinha28 : string "                                        "
inicialLinha29 : string "                                        "

; --- TELA GAME OVER ---
gameoverLinha0  : string "                                        "
gameoverLinha1  : string "                                        "
gameoverLinha2  : string "                                        "
gameoverLinha3  : string "        ___   __   __  __  ___          "
gameoverLinha4  : string "       / __| /  | |  |/  || __|         "
gameoverLinha5  : string "      | / _ / / | | |/| || _|           "
gameoverLinha6  : string "      |____/_/|_| |_|  |_||___|         "
gameoverLinha7  : string "                                        "
gameoverLinha8  : string "         ___  _  _  ___  ___            "
gameoverLinha9  : string "        / _ || || || __|| _ |           "
gameoverLinha10 : string "       | (_) | |/ || _| |   /           "
gameoverLinha11 : string "        |___/ |__/ |___||_|_            "
gameoverLinha12 : string "                                        "
gameoverLinha13 : string "                                        "
gameoverLinha14 : string "                                        "
gameoverLinha15 : string "                                        "
gameoverLinha16 : string "           FINAL SCORE:                 "
gameoverLinha17 : string "                                        "
gameoverLinha18 : string "                                        "
gameoverLinha19 : string "                                        "
gameoverLinha20 : string "                                        "
gameoverLinha21 : string "                                        "
gameoverLinha22 : string "        PRESS SPACE TO RESTART          "
gameoverLinha23 : string "                                        "
gameoverLinha24 : string "                                        "
gameoverLinha25 : string "                                        "
gameoverLinha26 : string "                                        "
gameoverLinha27 : string "                                        "
gameoverLinha28 : string "                                        "
gameoverLinha29 : string "                                        "


; ==============================================================================
;                         ROTINAS DE INICIALIZAÇÃO
; ==============================================================================

; - IMPRIME A TELA INICIAL DO JOGO
; Percorre as strings da memória e imprime linha por linha
print_title_screen:
    push r0
    push r1
    push r2
    push r3
    push r4
    
    loadn r0, #inicialLinha0   ; Aponta para o início da primeira string na RAM
    loadn r1, #0               ; Posição inicial na tela (0 = canto superior esquerdo)
    loadn r2, #30              ; Contador de linhas (tela tem 30 linhas)
    loadn r3, #41              ; Tamanho da string na memória (40 chars + '\0')
    loadn r4, #40              ; Tamanho da linha na tela (40 chars)
    
    print_title_loop:
        call print_string_pos   ; Imprime a linha apontada por r0 na posição r1
        
        add r0, r0, r3          ; Pula para a próxima string na memória
        add r1, r1, r4          ; Pula para a próxima linha visual
        dec r2                  ; Decrementa contador
        jnz print_title_loop    ; Repete até acabar as linhas
        
    pop r4
    pop r3
    pop r2
    pop r1
    pop r0


; ==============================================================================
;                         MAIN (LOOP PRINCIPAL)
; ==============================================================================
main:
  call limpa_score          ; Reinicia pontuação para 0
  loadn r0, #3000           
  store game_speed, r0      ; Reinicia a velocidade padrão
  
  ; LOOP DE ESPERA (START)
  ; Fica preso aqui até o jogador apertar ESPAÇO
  tela_de_inicio_botao:
  inchar  r3
  loadn   r4, #' '
  cmp r3, r4
  jne tela_de_inicio_botao
  
  call clear_screen         ; Limpa a tela inicial
  call print_cage           ; Desenha as bordas da arena

  ; --- Inicialização dos Registradores Principais ---
  ; r1 = Posição do Jogador
  ; r3, r4, r5 = Posições dos Inimigos (slots)
  
  loadn r1, #1020           ; Posição inicial da nave (centro-baixo)
  loadn r2, #0              
  loadn r3, #0              ; Slot Inimigo 1 (0 = vazio)
  loadn r4, #0              ; Slot Inimigo 2 (0 = vazio)
  loadn r5, #0              ; Slot Inimigo 3 (0 = vazio)
  loadn r6, #0
  loadn r7, #0

; - GAME LOOP - 
loop:
  call ship             ; 1. Lê input e move a nave
  call spawn_enemy      ; 2. Tenta criar inimigo (baseado em RNG)
  call delay            ; 3. Espera um pouco (controla FPS/Velocidade)
  call move_enemies     ; 4. Move inimigos para baixo e redesenha
  call collide_test     ; 5. Verifica se houve batida

  jmp loop              ; Repete infinitamente


; ==============================================================================
;                            JOGADOR (NAVE)
; ==============================================================================

ship:
  loadn r7, #0
  outchar r7, r1        ; Apaga a nave da posição antiga (imprime preto)

    moveship:
    push r1
    push r3
    push r4
    push r5
    inchar r1           ; Lê tecla pressionada (se houver)
    
    ; --- Mapeamento de Teclas ---
    loadn r5, #'a'
    cmp r1, r5
    jeq  left
    loadn r5, #'d'
    cmp r1, r5
    jeq right
    loadn r5, #'s'
    cmp r1, r5
    jeq down
    loadn r5, #'w'
    cmp r1, r5
    jeq up
    
    ; Se nenhuma tecla válida foi apertada, restaura registradores e desenha nave onde estava
    pop r5
    pop r4
    pop r3
    pop r1
    
    move_back:
    loadn r7, #42     ; Char '*' (Asterisco) para a nave
    loadn r6, #3584   ; Cor Azul Claro
    add r7, r7, r6    ; Combina Char + Cor
    outchar r7, r1    ; Desenha na tela
    rts

    ; --- Lógica de Movimento ---
    
    ; ESQUERDA
    left:
    pop r5
    pop r4
    pop r3
    pop r1
    dec r1      ; Move posição -1
    
    ; Colisão com parede esquerda
    loadn r7, #40
    mod r7, r1, r7      ; Pega o resto da divisão por 40 (coluna atual)
    loadn r6, #10       ; Parede esquerda está na coluna 10
    cmp r6, r7
    jeq move_left_over  ; Se bateu, desfaz movimento
    cmp r1, r3          ; Verifica se bateu em inimigo ao andar
    call collide_test   
    jmp move_back

    ; DIREITA
    right:
    pop r5
    pop r4
    pop r3
    pop r1
    inc r1      ; Move posição +1
    
    ; Colisão com parede direita
    loadn r7, #40
    mod r7, r1, r7
    loadn r6, #30       ; Parede direita está na coluna 30
    cmp r6, r7
    jeq move_right_over
    cmp r1, r3
    call collide_test
    jmp move_back

    ; BAIXO
    down:
    pop r5
    pop r4
    pop r3
    pop r1
    
    ; Colisão com parede de baixo
    loadn r7, #40
    add r1, r1, r7      ; Move posição +40 (linha de baixo)
    loadn r7, #1050     ; Limite inferior da tela jogável
    cmp r1, r7
    jeg move_down_over
    cmp r1, r3
    call collide_test
    jmp move_back

    ; CIMA
    up:
    pop r5
    pop r4
    pop r3
    pop r1
    
    ; Colisão com parede de cima
    loadn r7, #40
    sub r1, r1, r7      ; Move posição -40 (linha de cima)
    loadn r7, #320      ; Limite superior da tela jogável
    cmp r1, r7
    jel move_up_over
    cmp r1, r3
    call collide_test
    jmp move_back

    ; --- Correções de Limite (Undo Move) ---
    move_down_over:
    loadn r7, #40
    sub r1, r1, r7      ; Sobe de volta
    jmp move_back

    move_up_over:
    loadn r7, #40
    add r1, r1, r7      ; Desce de volta
    jmp move_back

    move_left_over:
    loadn r7, #1200
    inc r1              ; Vai pra direita
    jmp move_back

    move_right_over:
    loadn r7, #1200
    dec r1              ; Vai pra esquerda
    jmp move_back


; ==============================================================================
;                         COLISÃO E MORTE
; ==============================================================================

; Verifica se r1 (nave) está sobrepondo r3, r4 ou r5 (inimigos)
; Os inimigos têm largura de 3 blocos (pos, pos+1, pos+2)
collide_test:
    push r0
    push r2

    loadn r0, #0
    
    ; Teste Inimigo 1 (r3)
    cmp r3, r0          ; Se r3 for 0, não existe inimigo, pula
    jeq check_r5_col

    cmp r1, r3          ; Bateu na parte esquerda?
    jeq collide

    mov r2, r3
    inc r2              
    cmp r1, r2          ; Bateu no meio?
    jeq collide

    inc r2              
    cmp r1, r2          ; Bateu na direita?
    jeq collide
    
    ; Teste Inimigo 2 (r5)
    check_r5_col:
    cmp r5, r0
    jeq check_r4_col

    cmp r1, r5
    jeq collide

    mov r2, r5
    inc r2
    cmp r1, r2
    jeq collide

    inc r2
    cmp r1, r2
    jeq collide

    ; Teste Inimigo 3 (r4)
    check_r4_col:
    cmp r4, r0
    jeq end_collide_block

    cmp r1, r4
    jeq collide

    mov r2, r4
    inc r2
    cmp r1, r2
    jeq collide

    inc r2
    cmp r1, r2
    jeq collide

    end_collide_block:
    pop r2
    pop r0
    rts


; - ANIMAÇÃO DE MORTE E FIM DE JOGO
collide:
    ; Desenha uma "explosão" visual ao redor de r1
    loadn r7, #41
    sub r1, r1, r7
    loadn r6, #299
    outchar r6, r1
    inc r1
    loadn r6, #557
    outchar r6, r1
    inc r1
    loadn r6, #300
    outchar r6, r1
    loadn r7, #40
    add r1, r1, r7
    loadn r6, #558
    outchar r6, r1
    add r1, r1, r7
    loadn r6, #299
    outchar r6, r1
    dec r1
    loadn r6, #557
    outchar r6, r1
    dec r1
    loadn r6, #300
    outchar r6, r1
    sub r1, r1, r7
    loadn r6, #558
    outchar r6, r1
    
    jmp game_over_screen ; Vai para a tela de fim de jogo


; ==============================================================================
;                         INIMIGOS (SPAWN E MOVIMENTO)
; ==============================================================================

spawn_enemy:
    push r0
    push r1
    push r7

    ; RNG para decidir SE spawna
    call random
    loadn r0, #15
    mod r7, r7, r0
    loadn r0, #0
    cmp r7, r0
    jne spawn_end       ; Se não der 0 (1 em 15 chances), sai
    
    ; Tenta slot 1 (r3)
    loadn r0, #0
    cmp r3, r0              ; r3 está livre?
    jne try_spawn_r5        
    call get_random_pos     ; Calcula posição X aleatória
    mov r3, r7
    loadn r0, #'X'
    loadn r1, #2304         ; Cor VERMELHO
    add r0, r0, r1          
    outchar r0, r3          ; Desenha
    jmp spawn_end           

    ; Tenta slot 2 (r5)
    try_spawn_r5:
    cmp r5, r0
    jne try_spawn_r4
    call get_random_pos
    mov r5, r7
    loadn r0, #'X'
    loadn r1, #2304  
    add r0, r0, r1   
    outchar r0, r5
    jmp spawn_end

    ; Tenta slot 3 (r4)
    try_spawn_r4:
    cmp r4, r0
    jne spawn_end
    call get_random_pos
    mov r4, r7
    loadn r0, #'X'
    loadn r1, #2304  
    add r0, r0, r1   
    outchar r0, r4

    spawn_end:
    pop r7
    pop r1
    pop r0
    rts

; Move inimigos para baixo, apaga rastro e verifica se chegaram ao fim da tela
move_enemies:
    push r0
    push r1
    push r2

    ; --- Inimigo 1 (r3) ---
    loadn r0, #0
    cmp r3, r0
    jeq move_r5_block       ; Se vazio, pula

    ; Apaga posição antiga (3 chars de largura)
    mov r2, r3
    outchar r0, r2
    inc r2
    outchar r0, r2
    inc r2
    outchar r0, r2

    ; Desce uma linha (+40)
    loadn r1, #40
    add r3, r3, r1

    ; Verifica chão (limite 1080)
    loadn r1, #1080
    cmp r3, r1
    jgr kill_r3             ; Passou do chão -> destrói e pontua

    ; Redesenha na nova posição
    loadn r1, #'X'
    loadn r6, #2304         ; Vermelho
    add r1, r1, r6          
    mov r2, r3                 
    outchar r1, r2          
    inc r2
    outchar r1, r2
    inc r2
    outchar r1, r2
    jmp move_r5_block       

    kill_r3:
    call add_score          ; Aumenta score
    loadn r3, #0            ; Libera slot r3

    ; --- Inimigo 2 (r5) ---
    move_r5_block:
    cmp r5, r0
    jeq move_r4_block

    mov r2, r5
    outchar r0, r2
    inc r2
    outchar r0, r2
    inc r2
    outchar r0, r2

    loadn r1, #40
    add r5, r5, r1
    loadn r1, #1080
    cmp r5, r1
    jgr kill_r5

    loadn r1, #'X'
    loadn r6, #2304  
    add r1, r1, r6   
    mov r2, r5
    outchar r1, r2
    inc r2
    outchar r1, r2
    inc r2
    outchar r1, r2
    jmp move_r4_block

    kill_r5:
    call add_score
    loadn r5, #0

    ; --- Inimigo 3 (r4) ---
    move_r4_block:
    cmp r4, r0
    jeq move_end_block

    mov r2, r4
    outchar r0, r2
    inc r2
    outchar r0, r2
    inc r2
    outchar r0, r2

    loadn r1, #40
    add r4, r4, r1
    loadn r1, #1080
    cmp r4, r1
    jgr kill_r4

    loadn r1, #'X'
    loadn r6, #2304  
    add r1, r1, r6   
    mov r2, r4
    outchar r1, r2
    inc r2
    outchar r1, r2
    inc r2
    outchar r1, r2
    jmp move_end_block

    kill_r4:
    call add_score
    loadn r4, #0

    move_end_block:
    pop r2
    pop r1
    pop r0
    rts


; ==============================================================================
;                         GUI (INTERFACE GRÁFICA)
; ==============================================================================

; Desenha as paredes da arena
print_cage:
  push r1
  push r2
  push r3
  push r4

  ; Parede Esquerda
  loadn r1, #210   ; Posição inicial
  loadn r2, #40    ; Pulo de linha
  loadn r3, #0
  loadn r4, #22    ; Altura

  print_esq:
  outchar r2, r1
  add r1, r1, r2
  inc r3
  cmp r3, r4
  jne print_esq

  ; Parede Direita
  loadn r1, #230
  loadn r2, #41
  loadn r3, #0
  loadn r4, #22
  loadn r5, #40

  print_dir:
  outchar r2, r1
  add r1, r1, r5
  inc r3
  cmp r3, r4
  jne print_dir

  ; Parede Inferior (Chão)
  loadn r1, #1090
  loadn r2, #61     ; Caractere '='
  loadn r3, #0
  loadn r4, #21

  print_bot:
  outchar r2, r1
  inc r1
  inc r3
  cmp r3, r4
  jne print_bot

  pop r1
  pop r2
  pop r3
  pop r4
  rts


; Tela de Game Over
game_over_screen:
    call clear_screen          
    call print_gameover_static ; Desenha texto estático ("GAME OVER")
    
    loadn r1, #664             ; Posição para imprimir o score
    call print_score_final     ; Imprime números do score
    
    jmp main                   ; Reinicia o jogo
    
print_gameover_static:
    push r0
    push r1
    push r2
    push r3
    push r4
    
    loadn r0, #gameoverLinha0   
    loadn r1, #0             
    loadn r2, #30               
    loadn r3, #41           
    
    print_go_loop:
        call print_string_pos   
        
        add r0, r0, r3       
        loadn r4, #40
        add r1, r1, r4     
        dec r2
        jnz print_go_loop
        
    pop r4
    pop r3
    pop r2
    pop r1
    pop r0
    rts
    
    
; Imprime Score durante o jogo (Canto superior direito, amarelo)
print_score:
    push r0
    push r1
    push r2
    push r3
    push r4
    push r5
    push r6 

    load r0, score
    loadn r4, #10   ; Divisor para separar casas decimais
    loadn r2, #48   ; Código ASCII do '0'
    loadn r5, #2816 ; Cor AMARELO

    ; --- Dígito 1 (Unidade) ---
    mod r1, r0, r4 ; Pega o resto da divisão por 10 (ex: 123 -> 3)
    div r0, r0, r4 ; Atualiza r0 dividindo por 10 (ex: 123 -> 12)
    
    add r6, r1, r2 ; Converte int para ASCII
    add r6, r6, r5 ; Adiciona Cor
    
    loadn r3, #245 ; Posição na tela
    outchar r6, r3 
    
    ; --- Dígito 2 (Dezena) ---
    mod r1, r0, r4 
    div r0, r0, r4 
    
    add r6, r1, r2 
    add r6, r6, r5 
    
    loadn r3, #244 
    outchar r6, r3
    
    ; --- Dígito 3 (Centena) ---
    mod r1, r0, r4 
    
    add r6, r1, r2 
    add r6, r6, r5 
    
    loadn r3, #243 
    outchar r6, r3

    pop r6 
    pop r5
    pop r4
    pop r3
    pop r2
    pop r1
    pop r0
    rts
    
    
; Imprime uma string terminada em 0 (padrão C)
print_string_pos:
    push r0
    push r1
    push r2
    push r3
    
    mov r2, r0      ; r2 aponta memória
    mov r3, r1      ; r3 aponta tela
    
    print_string_loop:
        loadi r0, r2      ; Carrega char indireto
        loadn r1, #0
        cmp r0, r1        ; Verifica fim da string ('\0')
        jeq print_string_end
        
        outchar r0, r3    ; Imprime
        inc r2            ; Próximo char RAM
        inc r3            ; Próximo char Tela
        jmp print_string_loop
        
    print_string_end:
    pop r3
    pop r2
    pop r1
    pop r0
    rts
    
    
; Limpa a tela inteira (preenche com 0/preto)
clear_screen:
    push r0
    push r1
    push r2
    
    loadn r0, #0     
    loadn r1, #0     ; Inicio Tela
    loadn r2, #1200  ; Total Tela (30x40)
    
    clear_loop:
    outchar r0, r1  
    inc r1          
    cmp r1, r2       
    jne clear_loop    
    
    pop r2
    pop r1
    pop r0
    rts
    
    
; Imprime Score na tela de Game Over (Branco, centralizado)
print_score_final:
    push r0
    push r1
    push r2
    push r3
    push r4
    push r5
    push r6

    load r0, score      
    loadn r2, #48       
    loadn r4, #10       
    mov r3, r1          

    ; Milhar
    loadn r5, #1000
    div r6, r0, r5      
    mod r6, r6, r4    
    add r6, r6, r2      
    outchar r6, r3      
    inc r3              

    ; Centena
    loadn r5, #100
    div r6, r0, r5      
    mod r6, r6, r4      
    add r6, r6, r2
    outchar r6, r3
    inc r3

    ; Dezena
    loadn r5, #10
    div r6, r0, r5      
    mod r6, r6, r4
    add r6, r6, r2
    outchar r6, r3
    inc r3

    ; Unidade
    mod r6, r0, r4     
    add r6, r6, r2
    outchar r6, r3      

    pop r6
    pop r5
    pop r4
    pop r3
    pop r2
    pop r1
    pop r0
    rts
    
    

; ==============================================================================
;                         FERRAMENTAS E UTILITÁRIOS
; ==============================================================================

; - GERA UM VALOR ALEATÓRIO
; Usa Linear Congruential Generator: Next = (a * Prev + c) % m
random:
    push r0
    push r1
    push r2
    push r3

    load r0, random_a
    load r1, random_c
    load r2, random_m
    load r3, random_x

    mul r3, r3, r0
    add r3, r3, r1

    ; Incrementa 'c' a cada chamada para variar mais a sequência
    inc r1
    inc r3
    store random_c, r1
    add r3, r3, r1
    
    mod r3, r3, r2  ; Aplica o módulo

    store random_x, r3 ; Salva nova semente
    mov r7, r3         ; Retorna em r7

    pop r3
    pop r2
    pop r1
    pop r0
    rts


; Calcula coordenada X aleatória válida para spawnar inimigo
; Deve cair dentro das paredes (coluna 11 até 28 aprox)
get_random_pos:
    push r0

    call random

    loadn r0, #17      ; Limita largura
    mod r7, r7, r0

    loadn r0, #11      ; Adiciona Offset (pula parede esquerda)
    add r7, r7, r0

    loadn r0, #80      ; Adiciona Offset Y (começa na linha 2)
    add r7, r7, r0

    pop r0
    rts


; - DELAY (CONTROLE DE VELOCIDADE)
; Queima ciclos de CPU para o jogo não rodar instantaneamente
delay:
  push r0
  push r1
  
  load r1, game_speed   ; Carrega valor atual de delay
  
  delay1:
    loadn r0, #100      
      delay2:
        dec r0
        jnz delay2      ; Loop interno
        dec r1
        jnz delay1      ; Loop externo
        
  pop r1
  pop r0
  rts

; Zera o score na memória
limpa_score:
  push r0
  loadn r0, #0
  store score, r0
  pop r0
  rts
        
        
; Adiciona ponto e AUMENTA A DIFICULDADE
add_score:
    push r0
    push r1
    
    ; Incrementa Score
    load r0, score      
    loadn r1, #1       
    add r0, r0, r1      
    store score, r0    
    
    call print_score   ; Atualiza HUD
    
    ; Aumenta Velocidade (Diminui o Delay)
    push r2             
    load r2, game_speed
    loadn r1, #10        
    sub r2, r2, r1       ; Tira 10 ciclos do delay
    
    ; Limite de velocidade (não deixa ficar rápido demais/negativo)
    loadn r1, #200       
    cmp r2, r1
    jel skip_speed_up     
    
    store game_speed, r2 
    
    skip_speed_up:
      pop r2
      pop r1
      pop r0
    rts
