# Comunicação Série/Paralelo - Display LCD

## Objetivo:
Exercícios de familiarização com o gerenciamento das portas I/O.

## Contexto: 
Efetuar a comunicação do PIC12F675 com um LCD (16X2), utilizando um registrador de
deslocamento (shift register) para permitir envio dos dados.

## Especificações:
* Essa aplicação foi implementado com o kit disponível no LABEC2 (UFPB), que dispõe de um
PIC12F675, um registrador de deslocamento e um LCD (ver documentação específica -
Placa_LCD_1.pdf e Placa_LCD_2.pdf);
* Todas as linhas de controle para o registrador de deslocamento e para o LCD forão gerenciados pelo
PIC;
* O dado a ser transmitido ao LCD é enviado para um registrador de deslocamento (shift
register – 74164 – ver data sheet);
* Para que a transmissão do PIC ao shift register ocorra sem erros, as especificações do shift register
devem ser obedecidas;
* Para que o LCD receba os dados corretamente, um procedimentos de inicialização deve ser efetuado e
deve obedecer à sequência estabelecida na documentação do LCD (ver data sheet). Como o LCD é
um dispositivo "lento", tempos de espera especificados devem ser respeitados;
* O LCD foi configurado para receber dados em grupos de 4 bit;
* Após o procedimento de inicialização, escreva seu nome no LCD.
