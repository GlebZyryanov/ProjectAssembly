.model tiny		
.data ;сегмент данных программы
    N dw ?
	X dw ?
	Z dw ?
	M dw ?
	Q dw ?
	P dw ?
	L dw ?
	O dw ?
	Y dw ?
	input_buf db 06,00,5 dup(?); Буфер для ввода
	in_N db 0ah, 0dh, 'VVOD N :$';буферы для вывода сообщений
	in_X db 0ah, 0dh, 'VVOD X: $';о вводе переменных
	in_Z db 0ah, 0dh, 'VVOD Z: $'
	in_M db 0ah, 0dh, 'VVOD M: $'
	in_Q db 0ah, 0dh, 'VVOD Q: $'
	in_P db 0ah, 0dh, 'VVOD P: $'
	in_L db 0ah, 0dh, 'VVOD L: $'
	in_O db 0ah, 0dh, 'VVOD O: $'
	answer db 15 dup(?), '$';буфер для вывода сообщения о результате
	messout db 0dh, 0ah, 'OTVET : $';вывод
.code ;начало сегмента кода
.startup;директива начала программа 
 begin: jmp start
include bin2str.asm; Подключение программ для преобразования входных
include str2bin.asm; И выходных данных
start: 
lea  dx,in_N		; В DX адрес сообщения in_N 	
	mov ah,09h ; в AH - номер функции вывода строки
 	int 21h ; вызов прерывания DOS для вывода строки на экран
 	lea dx,input_buf ; в dx - адрес буфера ввода
 	mov ah,0ah ; в AH - номер функции ввода числа с клавиатуры
 	int 21h ; вызов прерывания ввода числа с клавиатуры
;преобразование строки в число
 	mov bx,dx ; перегрузить в bx адрес буфера
 	inc bx ; увеличить адрес на единицу
    call str2bin ; обратиться к подпрограмме преобразования
 	mov N,ax ; запомнить число в переменной N
;================Ввод 7 переменных ====================                 
lea  dx,in_X                        	 	
	mov ah,09h
 	int 21h 
 	lea dx,input_buf 
 	mov ah,0ah 
 	int 21h 
;преобразование строки в число
 	mov bx,dx 
 	inc bx 
    call str2bin 
 	mov X,ax
	
lea  dx,in_Z	 	
	mov ah,09h
 	int 21h 
 	lea dx,input_buf 
 	mov ah,0ah 
 	int 21h 
;преобразование строки в число
 	mov bx,dx 
 	inc bx 
    call str2bin 
 	mov Z,ax
	
lea  dx,in_M 	
	mov ah,09h
 	int 21h 
 	lea dx,input_buf 
 	mov ah,0ah 
 	int 21h 
;преобразование строки в число
 	mov bx,dx 
 	inc bx 
    call str2bin 
 	mov M,ax 
lea  dx,in_Q	 	
	mov ah,09h
 	int 21h 
 	lea dx,input_buf 
 	mov ah,0ah 
 	int 21h 
;преобразование строки в число
 	mov bx,dx 
 	inc bx 
    call str2bin 
 	mov Q,ax
	
lea  dx,in_P	 	
	mov ah,09h
 	int 21h 
 	lea dx,input_buf 
 	mov ah,0ah 
 	int 21h 
;преобразование строки в число
 	mov bx,dx 
 	inc bx 
    call str2bin 
 	mov P,ax
	
lea  dx,in_L	 	
	mov ah,09h
 	int 21h 
 	lea dx,input_buf 
 	mov ah,0ah 
 	int 21h 
;преобразование строки в число
 	mov bx,dx 
 	inc bx 
    call str2bin 
 	mov L,ax 
	
lea  dx,in_O 	
	mov ah,09h
 	int 21h 
 	lea dx,input_buf 
 	mov ah,0ah 
 	int 21h 
;преобразование строки в число
 	mov bx,dx 
 	inc bx 
    call str2bin 
 	mov O,ax 	
;===========Ввод 7 переменных окончен======================
;Y = X^Z^N + M^Q^P + L^O^(N/2)
mov Y,0; изначально результат =0
push X;поместить в стек х
push Z;и другие переменные 
push N;первого слагаемого
call power;ax = X^Z^N
add Y,ax;Добавить к результату
push M;
push Q;
push P;
call power;вызов подпрограммы
add Y,ax
push L;
push O;
mov ax,N;Загрузить в ах N 
cwd;Расширить знак
mov bx,2;в bx = 2
idiv bx;поделить N/2
push ax;N/2 в стек 
call power; вызов подпрограммы
add Y,ax;добавить к результату
mov ax,Y

lea bx,answer ; поместить в BX адрес буфера для символьного представления
call bin2str ; обратиться к подпрограмме преобразования
lea dx,messout ; в dx - адрес буфера вывода
mov ah,09h ; в ah - номер функции вывода на экран
int 21h ; обратиться к функции вывода через 21 прерывание
lea dx,answer+1
mov ah,09h
int 21h
int 20h ; а затем завершаем работу
;ПОДПРОГРАММА ВОЗВЕДЕНИЯ В СТЕПЕНЬ X1^X2^X3
power proc near
par3step equ [bp+8];через дерективу 
par2step equ [bp+6];EQU присвоили имена параметрам
par1step equ [bp+4]
push bp;стандарнтная входная
mov bp,sp;последовательность
mov ax,1;p=1
mov cx,par1step;в ax показатель степени - счетчик цикла
intcyc: push cx; счетчик цикла в стек
mov bx,par2step  
imul bx; P = p*z
pop cx;восстановить из стека сц
loop intcyc; замкнуть цикл 
mov cx,ax ;сохранить результат вычисления верхней степени в регистре cx
mov ax,1;p=1
intcyc2:push cx; счетчик цикла в стек 
mov bx,par3step;
imul bx;P = p*x
pop cx;восстановить из стека счетчик цикла 
loop intcyc2;замкнуть цикл 
pop bp;восстановили bp 
ret 6;возврат с очисткой стека от 3х параметров
power endp
;КОНЕЦ ПОДПРОГРАММЫ
end
