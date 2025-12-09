; --- Teste da Instrucao POW ---

; Teste 1: 2 elevado a 3 (Espero 8 em R0)
loadn r1, #2    ; Carrega 2 no R1
loadn r2, #3    ; Carrega 3 no R2
pow r0, r1, r2  ; R0 = R1 ^ R2

; Teste 2: -3 elevado a 2 (Espero 9 em R3)
loadn r4, #3   ; Carrega 3 no R4
loadn r5, #2    ; Carrega 2 no R5
pow r3, r4, r5  ; R3 = R4 ^ R5

HALT