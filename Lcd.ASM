;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*              MODIFICAÇÕES PARA USO COM 12F675                   *
;*                FEITAS PELO PROF. MARDSON                        *
;*                    FEVEREIRO DE 2014                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       NOME DO PROJETO                           *
;*                           CLIENTE                               *
;*         DESENVOLVIDO PELA MOSAICO ENGENHARIA E CONSULTORIA      *
;*   VERSÃO: 1.0                           DATA: 17/06/03          *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     DESCRIÇÃO DO ARQUIVO                        *
;*-----------------------------------------------------------------*
;*   MODELO PARA O PIC 12F675                                      *
;*                                                                 *
;*                                                                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ARQUIVOS DE DEFINIÇÕES                      *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
#INCLUDE <p12f675.inc>	;ARQUIVO PADRÃO MICROCHIP PARA 12F675

	__CONFIG _BODEN_OFF & _CP_OFF & _PWRTE_ON & _WDT_OFF & _MCLRE_ON & _INTRC_OSC_NOCLKOUT

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    PAGINAÇÃO DE MEMÓRIA                         *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;DEFINIÇÃO DE COMANDOS DE USUÁRIO PARA ALTERAÇÃO DA PÁGINA DE MEMÓRIA
#DEFINE	BANK0	BCF STATUS,RP0	;SETA BANK 0 DE MEMÓRIA
#DEFINE	BANK1	BSF STATUS,RP0	;SETA BANK 1 DE MAMÓRIA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                         VARIÁVEIS                               *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DOS NOMES E ENDEREÇOS DE TODAS AS VARIÁVEIS UTILIZADAS 
; PELO SISTEMA

	CBLOCK	0x20	;ENDEREÇO INICIAL DA MEMÓRIA DE
					;USUÁRIO
		W_TEMP		;REGISTRADORES TEMPORÁRIOS PARA USO
		STATUS_TEMP	;JUNTO ÀS INTERRUPÇÕES
		INICIA		;VARIÁVEL PARA INICIAR O LCD
	
		DADO		;ARMAZENA O DADO PARA A EEPROM
		DADO1
		DADO2
		CONT
		CONT2
		CONT3
		AUX
		
		;NOVAS VARIÁVEIS

	ENDC			;FIM DO BLOCO DE MEMÓRIA
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                        FLAGS INTERNOS                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DE TODOS OS FLAGS UTILIZADOS PELO SISTEMA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                         CONSTANTES                              *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DE TODAS AS CONSTANTES UTILIZADAS PELO SISTEMA
; INICIALIZAÇÃO DA EEPROM, DE ACORDO COM A DESCRIÇÃO NO ARQUIVO "Def_Rega_Formigas.inc"

;A PARTIR DO ENDEREÇO ZERO DA EEPROM, DADOS EM ORDEM ALEATÓRIA
	ORG 0x2100
		;A   l    e    x    a    n    d    r    e
	DE	0X41,0X6C,0X65,0X78,0X61,0X6E,0X64,0X72,0X65


;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                           ENTRADAS                              *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DE TODOS OS PINOS QUE SERÃO UTILIZADOS COMO ENTRADA
; RECOMENDAMOS TAMBÉM COMENTAR O SIGNIFICADO DE SEUS ESTADOS (0 E 1)

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                           SAÍDAS                                *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DE TODOS OS PINOS QUE SERÃO UTILIZADOS COMO SAÍDA
; RECOMENDAMOS TAMBÉM COMENTAR O SIGNIFICADO DE SEUS ESTADOS (0 E 1)

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       VETOR DE RESET                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	ORG	0x00			;ENDEREÇO INICIAL DE PROCESSAMENTO
	GOTO	INICIO
	
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    INÍCIO DA INTERRUPÇÃO                        *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; ENDEREÇO DE DESVIO DAS INTERRUPÇÕES. A PRIMEIRA TAREFA É SALVAR OS
; VALORES DE "W" E "STATUS" PARA RECUPERAÇÃO FUTURA

	ORG	0x04			;ENDEREÇO INICIAL DA INTERRUPÇÃO
	MOVWF	W_TEMP		;COPIA W PARA W_TEMP
	SWAPF	STATUS,W
	MOVWF	STATUS_TEMP	;COPIA STATUS PARA STATUS_TEMP

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    ROTINA DE INTERRUPÇÃO                        *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; AQUI SERÁ ESCRITA AS ROTINAS DE RECONHECIMENTO E TRATAMENTO DAS
; INTERRUPÇÕES

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                 ROTINA DE SAÍDA DA INTERRUPÇÃO                  *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; OS VALORES DE "W" E "STATUS" DEVEM SER RECUPERADOS ANTES DE 
; RETORNAR DA INTERRUPÇÃO

SAI_INT
	SWAPF	STATUS_TEMP,W
	MOVWF	STATUS		;MOVE STATUS_TEMP PARA STATUS
	SWAPF	W_TEMP,F
	SWAPF	W_TEMP,W	;MOVE W_TEMP PARA W
	RETFIE

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*	            	 ROTINAS E SUBROTINAS                      *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; CADA ROTINA OU SUBROTINA DEVE POSSUIR A DESCRIÇÃO DE FUNCIONAMENTO
; E UM NOME COERENTE ÀS SUAS FUNÇÕES.
LE_EEPROM
;LER DADO DA EEPROM, CUJO ENDEREÇO É INDICADO EM W
;DADO LIDO RETORNA EM W
	ANDLW	.127		;LIMITA ENDEREÇO MAX. 127
	BANK1				;ACESSO VIA BANK 1
	MOVWF	EEADR		;INDICA O END. DE LEITURA
	BSF		EECON1,RD	;INICIA O PROCESSO DE LEITURA
	MOVF	EEDATA,W	;COLOCA DADO LIDO EM W
	BANK0				;POSICIONA PARA BANK 0
	RETURN

GRAVA_EEPROM
;ESCREVE DADO (DADO) NA EEPROM, CUJO ENDEREÇO É INDICADO EM W
	ANDLW	.127		;LIMITA ENDEREÇO MAX. 127
	BANK1				;ACESSO VIA BANK 1
	MOVWF	EEADR
	MOVF	DADO,W
	MOVWF	EEDATA
	BSF		EECON1,WREN ;HABILITA ESCRITA
	BCF		INTCON,GIE	;DESLIGA INTERRUPÇÕES
	MOVLW	B'01010101'	;DESBLOQUEIA ESCRITA
	MOVWF	EECON2		;
	MOVLW	B'10101010'	;DESBLOQUEIA ESCRITA
	MOVWF	EECON2		;
	BSF		EECON1,WR ;INICIA A ESCRITA
AGUARDA
	BTFSC	EECON1,WR ;TERMINOU?
	GOTO	AGUARDA
	BSF		INTCON,GIE ;HABILITA INTERRUPÇÕES
	BANK0				;POSICIONA PARA BANK 0
	RETURN

SUBROTINA1
	;CORPO DA ROTINA
;SUBROTINA PARA TRATAR MEUS DADOS
TRATAR_DADOS
	MOVLW	.4 ;COMO IREI DIVIDIR O MEU BYTE UTILIZANDO 4 BITS PARA CADA VARIÁVEL
	MOVWF	CONT2	;INICIALMENTE PEGAREMOS OS 4 BITS MAIS SIGNIFICATIVOS
LOOP_DIV	
	RRF	DADO1
	BTFSS	DADO,7
	GOTO	CLEAR_DADO
	GOTO	SET_DADO
CLEAR_DADO
	BCF	DADO1,3
	GOTO	SAIR
SET_DADO
	BSF	DADO1,3
SAIR	
	RLF	DADO
	DECFSZ	CONT2
	GOTO	LOOP_DIV
	;PREENCHER DADO2
	MOVLW	.4  ;COMO IREI DIVIDIR O MEU BYTE UTILIZANDO 4 BITS PARA CADA VARIÁVEL
	MOVWF	CONT2	;POR ÚLTIMO PEGAREMOS 4 BITS MENOS SIGNIFICATIVOS
LOOP_DIV2	
	RRF	DADO2
	BTFSS	DADO,7
	GOTO	CLEAR_DADO2
	GOTO	SET_DADO2
CLEAR_DADO2
	BCF	DADO2,3
	GOTO	SAIR2
SET_DADO2
	BSF	DADO2,3
SAIR2	
	RLF	DADO
	DECFSZ	CONT2
	GOTO	LOOP_DIV2
	
	BSF	DADO1,4  ;SETANDO PARA O LCD IDENTIFICAR QUE É UMA ESCRITA DE DADOS
	BSF	DADO2,4	 ;SETANDO PARA O LCD IDENTIFICAR QUE É UMA ESCRITA DE DADOS
	RETURN
	
	
DELAY
	;FUNÇÃO PARA FAZER DELAY COM QUALQUER TEMPO
	MOVWF	TMR0
	BCF	INTCON, T0IF
LOOP_1
	BTFSS	INTCON,	T0IF
	GOTO	LOOP_1
	RETURN
	
;SUBROTINA PARA COLOCAR MEUS DADOS NO REGISTRADOR DE DESLOCAMENTO
REG_DESLOC
	BTFSS	INICIA,0
	GOTO	CLEAR_GP4
	GOTO	SET_GP4
CLEAR_GP4
	BCF	GPIO,GP4
	GOTO	CLOCK_REG
SET_GP4
	BSF	GPIO,GP4
CLOCK_REG ;CLOCK PARA DESLOCAR O DADO NO REGISTRADOR
	BSF	GPIO,GP0
	BCF	GPIO,GP0
	RRF	INICIA
	DECFSZ	CONT,F
	GOTO	REG_DESLOC
	;QUATRO PULSOS DE CLOCK PARA AJUSTAR MEU DADO NO REGISTRADOR
	BSF	GPIO,GP0
	BCF	GPIO,GP0
	BSF	GPIO,GP0
	BCF	GPIO,GP0
	BSF	GPIO,GP0
	BCF	GPIO,GP0
	BSF	GPIO,GP5
	BCF	GPIO,GP5
	RETURN

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIO DO PROGRAMA                          *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	
INICIO
	BANK1				;ALTERA PARA O BANCO 1
	MOVLW	B'00000000' ;CONFIGURA TODAS AS PORTAS DO GPIO (PINOS)
	MOVWF	TRISIO		;COMO SAÍDAS
	CLRF	ANSEL 		;DEFINE PORTAS COMO Digital I/O
	MOVLW	B'00000101'	;DEFININDO PRESCALE 1:64
	MOVWF	OPTION_REG	;DEFINE OPÇÕES DE OPERAÇÃO
	MOVLW	B'00000000'
	MOVWF	INTCON		;DEFINE OPÇÕES DE INTERRUPÇÕES
	BANK0				;RETORNA PARA O BANCO
	MOVLW	B'00000111'
	MOVWF	CMCON		;DEFINE O MODO DE OPERAÇÃO DO COMPARADOR ANALÓGICO

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIALIZAÇÃO DAS VARIÁVEIS                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ROTINA PRINCIPAL                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
MAIN
	;CORPO DA ROTINA PRINCIPAL
	;CONFIGURANDO O LCD. FAZENDO SUA INICIALIZAÇÃO
	MOVLW	.6
	CALL	DELAY
	MOVLW	B'00001100'
	MOVWF	INICIA
	MOVLW	.5
	MOVWF	CONT
	CALL	REG_DESLOC
	;ESPERAR CERCA DE 5ms
	MOVLW	.176
	CALL	DELAY
	MOVLW	B'00001100'
	MOVWF	INICIA
	MOVLW	.5
	MOVWF	CONT
	CALL	REG_DESLOC
	;ESPERAR CERCA DE 128us
	MOVLW	.254
	CALL	DELAY
	MOVLW	B'00001100'
	MOVWF	INICIA
	MOVLW	.5
	MOVWF	CONT
	CALL	REG_DESLOC
	;Function set ( Set interface to be 4 bits long. ) Interface is 8 bits in length.
	;ESPERAR CERCA DE 128us
	MOVLW	.254
	CALL	DELAY
	MOVLW	B'00000100'
	MOVWF	INICIA
	MOVLW	.5
	MOVWF	CONT
	CALL	REG_DESLOC
	;Function set ( Interface is 4 bits long. Specify the number of display lines and character font. )
	;The number of display lines and character font can not be changed after this point.
	;ESPERAR CERCA DE 128us
	MOVLW	.254
	CALL	DELAY
	MOVLW	B'00000100'
	MOVWF	INICIA
	MOVLW	.5
	MOVWF	CONT
	CALL	REG_DESLOC
	;PARTE 2 DO SYSTEM SET
	;ESPERAR CERCA DE 128us
	MOVLW	.254
	CALL	DELAY
	MOVLW	B'00000011'
	MOVWF	INICIA
	MOVLW	.5
	MOVWF	CONT
	CALL	REG_DESLOC
	;Display ON
	;ESPERAR CERCA DE 128us
	MOVLW	.254
	CALL	DELAY
	MOVLW	B'00000000'
	MOVWF	INICIA
	MOVLW	.5
	MOVWF	CONT
	CALL	REG_DESLOC
	;PARTE 2 DISPLAY ON
	;ESPERAR CERCA DE 128us
	MOVLW	.254
	CALL	DELAY
	MOVLW	B'00000011'
	MOVWF	INICIA
	MOVLW	.5
	MOVWF	CONT
	CALL	REG_DESLOC
	;Display clear
	;ESPERAR CERCA DE 128us
	MOVLW	.254
	CALL	DELAY
	MOVLW	B'00000000'
	MOVWF	INICIA
	MOVLW	.5
	MOVWF	CONT
	CALL	REG_DESLOC
	;PARTE 2 Display clear
	;ESPERAR CERCA DE 128us
	MOVLW	.254
	CALL	DELAY
	MOVLW	B'00001000'
	MOVWF	INICIA
	MOVLW	.5
	MOVWF	CONT
	CALL	REG_DESLOC
	;Entry mode set
	;ESPERAR CERCA DE 128us
	MOVLW	.254
	CALL	DELAY
	MOVLW	B'00000000'
	MOVWF	INICIA
	MOVLW	.5
	MOVWF	CONT
	CALL	REG_DESLOC
	;PARTE 2 Entry mode set
	;ESPERAR CERCA DE 128us
	MOVLW	.254
	CALL	DELAY
	MOVLW	B'00000100'
	MOVWF	INICIA
	MOVLW	.5
	MOVWF	CONT
	CALL	REG_DESLOC
	;ESCREVER OS DADOS!
	MOVLW	.200
	CALL	DELAY
	;COMO ESTOU USANDO A EEPROM, UTILIZO A VARIÁVEL CONT3 PARA ACESSAR AS 
	;POSIÇÕES DA MEMÓRIA DA EEPROM, COMEÇANDO PELA POSIÇÃO 0
	MOVLW	.0	
	MOVWF	CONT3
LOOP_DADOS	
	MOVLW	.254
	CALL	DELAY
	MOVFW	CONT3
	CALL	LE_EEPROM
	MOVWF	DADO
	;DEPOIS DE PEGAR A LETRA NA EEPROM, CHAMO UMA SUBROTINA PARA TRATAR OS
	;DADOS, POIS É PRECISO DIVIDIR OS DADOS, POIS SÓ MANDAREMOS 4 BITS DA LETRA
	;POR VEZ
	CALL	TRATAR_DADOS
	;DEPOIS DE DIVIDIR O DADO ESCREVO NO LCD
	;MANDO INICIALMENTE A PRIMEIRA PARTE DA LETRA PARA O LCD
	MOVFW	DADO1
	MOVWF	INICIA
	MOVLW	.5
	MOVWF	CONT
	CALL	REG_DESLOC
	MOVLW	.254
	CALL	DELAY
	;DEPOIS ENVIO A SEGUNDA PARTE DA LETRA PARA O LCD
	MOVFW	DADO2
	MOVWF	INICIA
	MOVLW	.5
	MOVWF	CONT
	CALL	REG_DESLOC
	;FIM DA ESCRITA DO CARACTER
	INCF	CONT3,F ;INCREMENTO PARA ACESSAR A PRÓXIMA POSIÇÃO DA EEPROM
	MOVFW	CONT3
	MOVWF	AUX
	MOVLW	.9
	SUBWF	AUX,W	;SE JA TIVER ACESSADO A EEPROM 9 VEZES 
	BTFSS	STATUS,Z    ;É PORQUE JÁ FOI ESCRITO TUDO QUE EU QUERIA NO LCD
	GOTO	LOOP_DADOS  ;SENÃO, ELE ACESSA O PRÓXIMO ENDEREÇO DA EEPROM PARA ESCREVER O DADO	
	
FIM
	GOTO FIM

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       FIM DO PROGRAMA                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	END
