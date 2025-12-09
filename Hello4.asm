; Caio Mendes Laprega
; Larry Felipe Silva Gonçalves
; Yan Barbosa Servilha

; INVASAO ESPACIAL

jmp print_title_screen

; --- Declaração de Variáveis Globais ---
random_a: var #1
random_c: var #1
random_m: var #1
random_x: var #1
score: var #1
game_speed: var #1

; --- Inicialização de Variáveis Estáticas ---
static random_a+#0, #25173 
static random_c+#0, #13849
static random_m+#0, #65535
static random_x+#0, #7 
static score+#0, #0
static game_speed + #0, #3000


; --- TELA INICIAL (30 Linhas de 40 Caracteres) ---

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

; --- TELA GAME OVER (30 Linhas de 40 Caracteres) ---

gameoverLinha0  : string "                                        "
gameoverLinha1  : string "                                        "
gameoverLinha2  : string "                                        "
gameoverLinha3  : string "      ___   __   __  __  ___            "
gameoverLinha4  : string "     / __| /  | |  |/  || __|           "
gameoverLinha5  : string "    | / _ / / | | |/| || _|             "
gameoverLinha6  : string "    |____/_/|_| |_|  |_||___|           "
gameoverLinha7  : string "                                        "
gameoverLinha8  : string "       ___  _  _  ___  ___              "
gameoverLinha9  : string "      / _ || || || __|| _ |             "
gameoverLinha10 : string "     | (_) | |/ || _| |   /             "
gameoverLinha11 : string "      |___/ |__/ |___||_|_|             "
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
gameoverLinha22 : string "      PRESS SPACE TO RESTART            "
gameoverLinha23 : string "                                        "
gameoverLinha24 : string "                                        "
gameoverLinha25 : string "                                        "
gameoverLinha26 : string "                                        "
gameoverLinha27 : string "                                        "
gameoverLinha28 : string "                                        "
gameoverLinha29 : string "                                        "



; - IMPRIME A TELA INICIAL DO JOGO
; - (Fora da função main, pois não será mais impresso após um game over, onde a função main vai ser chamada novamente)
print_title_screen:
    push r0
    push r1
    push r2
    push r3
    push r4
    
    loadn r0, #inicialLinha0   ; Endereço de memória na primeira string
    loadn r1, #0               ; Posição na tela
    loadn r2, #30              ; Contador de linhas
    loadn r3, #41              ; Pulo para a próxima linha na memória        
    loadn r4, #40              ; Pulo para a próxima linha na tela
    
    print_title_loop:
        call print_string_pos   
        
        add r0, r0, r3          ; Avança para a próxima string na memória          
        add r1, r1, r4          ; Avança para a próxima linha na tela
        dec r2                 
        jnz print_title_loop    
        
    pop r4
    pop r3
    pop r2
    pop r1
    pop r0



; - MAIN - Inicio do jogo
main:
  call limpa_score          ; Zera a pontuação na RAM
  loadn r0, #3000           
  store game_speed, r0      ; Reseta a velocidade para a velocidade inicial do jogo
  
  ; LOOP DE ESPERA
  ; Aguarda até o jogador apertar SPACE para continuar a execução
  tela_de_inicio_botao:
  inchar  r3
  loadn   r4, #' '
  cmp r3, r4
  jne tela_de_inicio_botao
  
  call clear_screen         ; Limpa a tela
  call print_cage           ; Desenha a arena na tela


  ; --- Inicialização dos Registradores do Jogo ---
  
  loadn r1, #1020           ; Posição da nave
  loadn r2, #0              
  loadn r3, #0              ; Posição dos inimigos
  loadn r4, #0              ; ''''''''''''''''''''
  loadn r5, #0              ; ''''''''''''''''''''
  loadn r6, #0
  loadn r7, #0


; - LOOP - Loop principal de execução do jogo
loop:
  call ship             ; Lê o teclado e move a nave
  call spawn_enemy      ; Tenta criar novos inimigos
  call delay            ; Controla a velocidade do jogo
  call move_enemies     ; Faz os inimigos cairem
  call collide_test     ; Verifica se a nave bateu em algum inimigo

  jmp loop              ; Repete o loop


;=================================================
;                NAVE (jogador)
;=================================================

; - MOVIMENTAÇÃO DA NAVE
ship:
  loadn r7, #0
  outchar r7, r1        ; Apaga a nave da posição antiga (escreve preto)

    moveship:
    push r1
    push r3
    push r4
    push r5
    inchar r1           ; Lê o teclado
    
    ; VERIFICA AS TECLAS W A S D
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
    
    ; SE NADA FOI APERTADO, NÃO PULA PARA AS FUNÇÕES DE MOVER A NAVE
    pop r5
    pop r4
    pop r3
    pop r1

    
    ; DESENHA A NAVE NA NOVA POSIÇÃO (OU NA MESMA, SE NÃO MOVEU)
    move_back:
    loadn r7, #42     ; Carrega o caractere da nave (#42)
    loadn r6, #3584   ; Carrega a cor azul claro
    add r7, r7, r6    ; Caractere + Cor = Caractere Azul Claro
    outchar r7, r1    ; Imprime a nave colorida
    rts

    ; MOVIMENTO PARA A ESQUERDA
    left:
    pop r5
    pop r4
    pop r3
    pop r1
    dec r1      ; Move r1 para a esquerda
    
    ; VERIFICA A PAREDE DA ESQUERDA, PARA EVITAR O JOGADOR DE SAIR DA ARENA
    ; r1 = posição do jogador
    loadn r7, #40
    mod r7, r1, r7
    loadn r6, #10
    cmp r6, r7
    jeq move_left_over
    cmp r1, r3
    call collide_test   ; Verifica se bateu em algum inimigo quando andou
    jmp move_back

    
    ; MOVIMENTO PARA A DIREITA
    right:
    pop r5
    pop r4
    pop r3
    pop r1
    inc r1      ; Move r1 para a direita
    
    ; VERIFICA A PAREDE DA DIREITA, PARA EVITAR O JOGADOR DE SAIR DA ARENA
    ; r1 = posição do jogador
    loadn r7, #40
    mod r7, r1, r7
    loadn r6, #30
    cmp r6, r7
    jeq move_right_over
    cmp r1, r3
    call collide_test   ; Verifica se bateu em algum inimigo quando andou
    jmp move_back

    
    ; MOVIMENTO PARA BAIXO
    down:
    pop r5
    pop r4
    pop r3
    pop r1
    
    ; VERIFICA A PAREDE DE BAIXO, PARA EVITAR O JOGADOR DE SAIR DA ARENA
    ; r1 = posição do jogador
    loadn r7, #40
    add r1, r1, r7      ; Move r1 para baixo
    loadn r7, #1050
    cmp r1, r7
    jeg move_down_over
    cmp r1, r3
    call collide_test   ; Verifica se bateu em algum inimigo quando andou
    jmp move_back


    ; MOVIMENTO PARA CIMA
    up:
    pop r5
    pop r4
    pop r3
    pop r1
    
    ; VERIFICA A PAREDE DE CIMA, PARA EVITAR O JOGADOR DE SAIR DA ARENA
    ; r1 = posição do jogador
    loadn r7, #40
    sub r1, r1, r7      ; Move r1 para cima
    loadn r7, #320
    cmp r1, r7
    jel move_up_over
    cmp r1, r3
    call collide_test   ; Verifica se bateu em algum inimigo quando andou
    jmp move_back


    ; CORREÇÃO EM CASO DE COLISÃO COM A PAREDE
    
    move_down_over:
    loadn r7, #40
    sub r1, r1, r7      ; Corrige o valor de r1
    jmp move_back       ; Imprime a nave com r1 corrigido

    move_up_over:
    loadn r7, #40
    add r1, r1, r7
    jmp move_back

    move_left_over:
    loadn r7, #1200
    inc r1
    jmp move_back

    move_right_over:
    loadn r7, #1200
    dec r1
    jmp move_back


; - CHECA COLISÃO COM CADA UM DOS INIMIGOS (r3, r5 e r4)
collide_test:
    push r0
    push r2

    loadn r0, #0
    
    
    ; Teste primeiro inimigo (r3)
    cmp r3, r0          ; Verifica se existe o inimigo
    jeq check_r5_col

    cmp r1, r3          ; Bateu na esquerda do bloco?
    jeq collide

    mov r2, r3
    inc r2              ; Bloco do meio
    cmp r1, r2          ; Bateu no bloco do meio?
    jeq collide

    inc r2              ; Bloco da direita
    cmp r1, r2          ; Bateu no bloco da direita?
    jeq collide
    
    
    ; Teste do segundo inimigo (r5)
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


    ; Teste do terceiro inimigo (r4)
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


; - SE COLIDIR, TERMINA O JOGO
collide:

    ; Desenha uma explosão ao redor da nave
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
    
    ; Vai para a tela final
    jmp game_over_screen




;=================================================
;             INIMIGOS
;=================================================

; - SPAWNA INIMIGO NA POSIÇÃO CRIADA POR RANDOM_POS
spawn_enemy:
    push r0
    push r1
    push r7

    ; Decide se vai spawnar (Aleatoriedade)
    call random
    loadn r0, #15
    mod r7, r7, r0
    loadn r0, #0
    cmp r7, r0
    jne spawn_end       ; Se não for 0, não spawna nada agora
    
    
    ; Tenta preencher o slot 1 (r3)
    loadn r0, #0
    cmp r3, r0              ; Verifica se r3 está ocupado
    jne try_spawn_r5        ; Se estiver: vai para o slot 2 (r5)
    call get_random_pos     ; Se não estiver, continua criando o inimigo
    mov r3, r7
    loadn r0, #'X'
    loadn r1, #2304         ; Carrega a cor VERMELHO
    add r0, r0, r1          ; Soma: X + Vermelho = X Vermelho
    outchar r0, r3
    jmp spawn_end           


    ; Tenta preencher o slot 2 (r5)
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


    ; Tenta preencher o slot 3 (r4)
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


; - MOVIMENTA OS INIMIGOS ATÉ O FINAL DA TELA, E ELIMINA SE NECESSÁRIO
move_enemies:
    push r0
    push r1
    push r2

    ; Inimigo do slot 1 (r3)
    loadn r0, #0
    cmp r3, r0
    jeq move_r5_block       ; Se o inimigo não existe, vai para o slot 2

    ; Apaga o inimigo na posicão atual (desenha 3 espaços pretos)
    mov r2, r3
    outchar r0, r2
    inc r2
    outchar r0, r2
    inc r2
    outchar r0, r2

    ; Vai para a linha de baixo (soma 40)
    loadn r1, #40
    add r3, r3, r1

    ; Verifica se bateu no chão
    loadn r1, #1080
    cmp r3, r1
    jgr kill_r3             ; Se passou do chão pula para a eliminação do inimigo

    ; Desenha o inimigo na posição nova
    loadn r1, #'X'
    loadn r6, #2304         ; VERMELHO
    add r1, r1, r6          ; Soma o caractere e a cor
    mov r2, r3                 
    outchar r1, r2          ; Desenha os inimigos nas posições novas
    inc r2
    outchar r1, r2
    inc r2
    outchar r1, r2
    jmp move_r5_block       ; Pula a função de eliminar o bloco

    kill_r3:
    call add_score          ; Ganha um ponto
    loadn r3, #0            ; Libera o slot para o spawn de um novo inimigo

    
    ; Inimigo do slot 2 (r5)
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


    ; Inimigo do slot 3 (r4)
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




;=================================================
;             GUI
;=================================================

; - IMPRIME AS PAREDES DO JOGO
print_cage:
  push r1
  push r2
  push r3
  push r4

  loadn r1, #210
  loadn r2, #40
  loadn r3, #0
  loadn r4, #22

  print_esq:
  outchar r2, r1
  add r1, r1, r2
  inc r3
  cmp r3, r4
  jne print_esq

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

  loadn r1, #1090
  loadn r2, #61
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


; - TELA DE GAME OVER 
game_over_screen:
    call clear_screen          
    call print_gameover_static 
    

   

    
    loadn r1, #664             
    call print_score_final     
    
  

    jmp main               
    
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
    
    
; - IMPRIME O SCORE NA TELA
print_score:
    push r0
    push r1
    push r2
    push r3
    push r4
    push r5
    push r6 ; Protege r6 que será usado como caractere colorido

    load r0, score
    loadn r4, #10 ; Divisor 10
    loadn r2, #48 ; ASCII '0'
    loadn r5, #2816 ; Carrega a cor AMARELO

; --- Dígito 1 (Unidade) ---
    mod r1, r0, r4; r1 = Dígito
    div r0, r0, r4 ; r0 = Resto (Próxima divisão)
    
    add r6, r1, r2 ; r6 = Dígito ASCII
    add r6, r6, r5 ; r6 = Dígito AMARELO
    
    loadn r3, #245 ; Posição do digito 1
    outchar r6, r3 ; Imprime
    
; --- Dígito 2 (Dezena) ---
    mod r1, r0, r4 ; r1 = Dígito
    div r0, r0, r4 ; r0 = Resto
    
    add r6, r1, r2 ; r6 = Dígito ASCII
    add r6, r6, r5 ; r6 = Dígito AMARELO
    
    loadn r3, #244 ; Posição do digito 2
    outchar r6, r3
    
; --- Dígito 3 (Centena) ---
    mod r1, r0, r4 ; r1 = Dígito
    
    add r6, r1, r2 ; r6 = Dígito ASCII
    add r6, r6, r5 ; r6 = Dígito AMARELO
    
    loadn r3, #243 ; Posição do digito 3
    outchar r6, r3

    pop r6 ; Restaura r6
    pop r5
    pop r4
    pop r3
    pop r2
    pop r1
    pop r0
    rts
    
    
; - IMPRIME STRING
print_string_pos:
    push r0
    push r1
    push r2
    push r3
    
    mov r2, r0     
    mov r3, r1      
    
    print_string_loop:
        loadi r0, r2      
        loadn r1, #0
        cmp r0, r1         
        jeq print_string_end
        
        outchar r0, r3      
        inc r2              
        inc r3            
        jmp print_string_loop
        
    print_string_end:
    pop r3
    pop r2
    pop r1
    pop r0
    rts
    
    
; - LIMPA TODOS OS CARACTERES DA TELA
clear_screen:
    push r0
    push r1
    push r2
    
    loadn r0, #0     
                     
    
    loadn r1, #0     
    loadn r2, #1200  
    
    clear_loop:
    outchar r0, r1  
    inc r1          
    cmp r1, r2       
    jne clear_loop    
    
    pop r2
    pop r1
    pop r0
    rts
    
    
; - IMPRIME SOMENTE OS PONTOS NA TELA DE GAME OVER
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

   
    loadn r5, #1000
    div r6, r0, r5      
    mod r6, r6, r4    
    add r6, r6, r2      
    outchar r6, r3      
    inc r3              

    
    loadn r5, #100
    div r6, r0, r5      
    mod r6, r6, r4      
    add r6, r6, r2
    outchar r6, r3
    inc r3

    loadn r5, #10
    div r6, r0, r5      
    mod r6, r6, r4
    add r6, r6, r2
    outchar r6, r3
    inc r3

    
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
    
    

;=================================================
;             MISC
;=================================================

; - GERA UM VALOR ALEATORIO
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

    ; === Incrementa o c a cada chamada ===
    inc r1
    inc r3
    store random_c, r1
    add r3, r3, r1
    ; =============================================
    mod r3, r3, r2

    store random_x, r3
    mov r7, r3

    pop r3
    pop r2
    pop r1
    pop r0
    rts


; - TRANSFORMA O VALOR ALEATORIO EM UMA COORDENADA PARA GERAR UM INIMIGO
get_random_pos:
    push r0

    call random

    loadn r0, #17
    mod r7, r7, r0

    loadn r0, #11
    add r7, r7, r0

    loadn r0, #80
    add r7, r7, r0

    pop r0
    rts


; - CONSOME CICLOS DO PROCESSADOR PARA AJUSTAR A VELOCIDADE DO JOGO
delay:
  push r0
  push r1
  
  load r1, game_speed   
  
  delay1:
    loadn r0, #100      
      delay2:
        dec r0
        jnz delay2
        dec r1
        jnz delay1
        
  pop r1
  pop r0
  rts

; - REINICIA A PONTUAÇÃO
limpa_score:
  push r0
  
  loadn r0, #0
  store score, r0
  
  pop r0
  rts
        
        
; - ADICIONA PONTOS AO SCORE
add_score:
    push r0
    push r1
    
    load r0, score      
    loadn r1, #1       
    add r0, r0, r1      
    
    store score, r0    
    
    call print_score   
    
    push r2             
    load r2, game_speed
    loadn r1, #10        
    sub r2, r2, r1
    
 
    loadn r1, #200       
    cmp r2, r1
    jel skip_speed_up     
    
    store game_speed, r2 
    
    skip_speed_up:
      pop r2
      pop r1
      pop r0
    rts

