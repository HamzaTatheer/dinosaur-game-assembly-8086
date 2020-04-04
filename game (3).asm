[org 0x0100]
jmp Entry
score: dw 0
x_offset: dw 4
y_offset: dw 9

;player address will store the player matrict(player,duck) to be displayed. space key press ? mov pa,p space release ? mov pa,p_d (short forms of names for explanation)
player_address: dw 0

player: db 0,0,0,0,0,0,0,0,0,0,0,
  row1: db 0,0,0,0,0,0,0,0,0,0,0,
  row2: db 0,0,0,0,0,0,0,0,0,0,0,
  row3: db 0,0,0,0,0,0,0,0,0,0,0,
  row4: db 0,0,0,0,0,0,0,0,0,0,0,
  row5: db 0,0,0,0,0,0,0,0,0,0,0,
  row6: db 0,0,0,0,0,1,1,1,4,0,0,
  row7: db 0,0,0,0,0,1,2,0,4,0,0,
  row8: db 0,0,0,0,0,1,1,1,4,0,0,
  row9: db 0,1,4,0,0,1,1,4,0,0,0,
  rowA: db 0,1,1,4,4,1,1,4,0,0,0,
  rowB: db 0,1,1,1,1,1,1,4,0,0,0,
  rowC: db 0,4,1,1,1,1,1,4,0,0,0,
  rowD: db 0,0,4,1,1,1,1,4,0,0,0,
  rowE: db 0,0,0,4,1,4,1,4,0,0,0,
  rowF: db 0,0,0,0,0,0,0,0,0,0,0,
 
player_duck: db 0,0,0,0,0,0,0,0,0,0,0,
  drow1: db 0,0,0,0,0,0,0,0,0,0,0,
  drow2: db 0,0,0,0,0,0,0,0,0,0,0,
  drow3: db 0,0,0,0,0,0,0,0,0,0,0,
  drow4: db 0,0,0,0,0,0,0,0,0,0,0,
  drow5: db 0,0,0,0,0,0,0,0,0,0,0,
  drow6: db 0,0,0,0,0,0,0,0,0,0,0,
  drow7: db 0,0,0,0,0,0,0,0,0,0,0,
  drow8: db 0,0,0,0,0,0,0,0,0,0,0,
  drow9: db 0,1,4,0,0,1,1,1,4,0,0,
  drowA: db 0,1,1,4,4,1,2,0,4,0,0,
  drowB: db 0,1,1,1,1,1,1,1,4,0,0,
  drowC: db 0,4,1,1,1,1,1,4,0,0,0,
  drowD: db 0,0,4,1,1,1,1,4,0,0,0,
  drowE: db 0,0,0,4,1,4,1,4,0,0,0,
  drowF: db 0,0,0,0,0,0,0,0,0,0,0, 
  
collided: dw 0 
 
;===========================OBJ CODE START==============================
 
obj_pixel_color: dw 0xE000
  
;Actual Steps to display OBJ
;1.Display Blocks with Create_objects            (reads array linearly but keeps track of when row and collumn change.
;2.Delete_objects with Delete_objects
;3.Shift the array values to left circularly with shift_objects     (reads array line by line and shifts left)
;4.This is written in timer isr to happen continuously

;Change values of 1 and get new objs
;The length could be increased and new obj added but all values of '80' and '79' need to be changed accordingly
objects: db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0
object2: db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
object3: db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
object4: db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
object5: db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
object6: db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
object7: db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
object8: db 1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0



;This is an easy way to add asss many objects as you want. Example 
;mov objects,obj9999
;call obj_move_left
;but first create an array of it object9999: dw time 80
;ALso this is a bit of long process. You need to change

shift_objects:
pushA
;Get first array and shift left and proceed as follows
mov bx,objects
call obj_move_left

mov bx,object2
call obj_move_left

mov bx,object3
call obj_move_left

mov bx,object4
call obj_move_left

mov bx,object5
call obj_move_left

mov bx,object6
call obj_move_left

mov bx,object7
call obj_move_left

mov bx,object8
call obj_move_left


popA
ret



;Gets the array address in bx and shifts all of its elements one time to left. eg 01101 to 11010
;The array with being handled is hardcoded for 80
shift_left:
pushA

mov dx,0

shift_all:
add dx,1
mov cx,[bx+1]
mov [bx],cx

add bx,1
cmp dx,79
jne shift_all
popA
ret







;it shifts the object matrix from right to left but it is circular linked. See how ax is handled and sent from first to last index
obj_move_left:
push ax
mov ax,[bx]
call shift_left
mov [bx+79],ah
pop ax
ret





Create_objects:
pushA
mov cx,0
mov si,0
mov di,0
;si = x,di = y
mov bx,objects

;purpose of condistions is to convert 1d coordinate to x:si and y:di values.These can later be given to 'CreatePixel(color,x,y)'
complete_obj_pixel:
cmp si,79
jna y_coord_adjusted_obj
; adjust y coord here
sub si,80
add di,1
y_coord_adjusted_obj:
mov ax,[bx]
cmp al,0
je skip_obj_pixel


push word [obj_pixel_color]

add si,0;x coord for position of blocks
add di,17;y coord for position of blocks
push si
push di
sub si,0;x coord for position of blocks
sub di,17;y coord for position of blocks
call CreatePixel ; creates a pixels at coordinates pushed


skip_obj_pixel:
add si,1
add bx,1
add cx,1
cmp cx,640;Collumns * no_of_objects
jne complete_obj_pixel
popA
ret













;copy of create, for delete

Delete_objects:
pushA
mov cx,0
mov si,0
mov di,0
;si = x,di = y
mov bx,objects

delete_obj_pixel:
cmp si,79
jna y_coord_adjusted_delete_obj
; adjust y coord here
sub si,80
add di,1
 y_coord_adjusted_delete_obj:
mov ax,[bx]
cmp al,0
je skip_delete_obj_pixel


push 0x0000

add si,0;x coord
add di,17;y coord
push si
push di
sub si,0;x coord
sub di,17;y coord
call CreatePixel


skip_delete_obj_pixel:
add si,1
add bx,1
add cx,1
cmp cx,640
jne delete_obj_pixel
popA
ret

;===============================OBJ CODE END===================================

;CreatePixel(color,x,y) taken from stack
CreatePixel:
push bp
mov bp,sp
push es
push ax
push si
push bx
mov si,0
mov ax,0
mov bx,0

;simple load and display the pixel by a simple formula. shl(80*x+y) = 2*(80*x+y)
push 0xb800
pop es
mov ax,[bp+4]
mov si,80
mul si
add ax,[bp+6]
shl ax,1
mov si,ax
mov bx,[bp+8]

mov word [es:si],bx

pop bx
pop si
pop ax
pop es
mov sp,bp
pop bp
ret 6


;====================================PLAYER CODE START=============================

; Same Code as Create_objects but wit values adjusted for the matrix
; Also x_offset and y_offset is used to avoid hard coded values as in obj
CreatePlayer:
push bp
mov bp,sp
push ax
push bx
push cx
push dx
push si
push di

mov ax,[bp+6]
mov [x_offset],ax;Get new x and update x_offset
mov ax,[bp+4]
mov [y_offset],ax;Get new y and update y_offset
mov ax,0

mov cx,0
mov si,0
mov di,0
;si = x,di = y
mov bx,[player_address];can be player matrix or player_duck

complete_player_pixel:
cmp si,10
jna y_coord_adjusted
;Simply converting matrix index to x:si and y:di
sub si,11
add di,1
y_coord_adjusted:
mov ax,[bx];Get Current matrix Value
cmp al,0;skip all code if its 0. Or else print it according to the value stored
je skip_pixel
cmp al,4
je skip_pixel
cmp al,2
je print_white_skin
cmp al,3
je print_eye
push 0xA000
continue_skin:
add si,[bp+6];x coord passed
add di,[bp+4];y coord passed
push si
push di
sub si,[bp+6];x coord passed
sub di,[bp+4];y coord passed
call CreatePixel
skip_pixel:
add si,1
add bx,1
add cx,1
cmp cx,176; Total matrix indexes
jne complete_player_pixel



pop di
pop si
pop dx
pop cx
pop bx
pop ax
mov sp,bp
pop bp
ret 4

;Changing push values according to value give in al from array matrix of player
print_white_skin:
push 0xFF21
jmp continue_skin
print_eye:
push 0x7931
jmp continue_skin





;Same code as CreatePlayer but with CreatePixel(0,x,y) ie color is 0000
ClearPlayer:
push bp
mov bp,sp
push ax
push bx
push cx
push dx
push si
push di

mov cx,0
mov si,0
mov di,0
;si = x,di = y
mov bx,[player_address]

complete_player_clear:
cmp si,10
jna y_coord_adjusted_clr
; adjust y coord here
sub si,11
add di,1
y_coord_adjusted_clr:
mov ax,[bx]
cmp al,0
je skip_pixel_clr
cmp al,4
je skip_pixel_clr
push 0x0000
add si,[x_offset];x coord
add di,[y_offset];y coord
push si
push di
sub si,[x_offset]
sub di,[y_offset]
call CreatePixel
skip_pixel_clr:
add si,1
add bx,1
add cx,1
cmp cx,176
jne complete_player_clear



pop di
pop si
pop dx
pop cx
pop bx
pop ax
mov sp,bp
pop bp
ret





movePlayer:
push bp
mov bp,sp
push ax
push bx
push cx
push si
push di

call ClearPlayer

;Gets x offset and y offset and adds it in parameters passed and also in itself
mov ax,[x_offset]
add [bp+6],ax

mov ax,[bp+6]
add word [x_offset],ax

;-----------------------

;------------updates both x_offset and local parameter to same value as above
mov ax,[y_offset]
add [bp+4],ax

mov ax,[bp+4]
add word [y_offset],ax


;After updating x and y. Call func to print player
push word [bp+6]
push word [bp+4]
call CreatePlayer

pop di
pop si
pop cx
pop bx
pop ax
mov sp,bp
pop bp
ret 4
delay:
push ax
mov ax,0
complete_delay:
add ax,1
cmp ax,0xFFFF
jne complete_delay
pop ax
ret



;===========================A function that can be used to make the player jump=================
jump_player:
push 0
push 0
call movePlayer
call delay
push 0
push -1
call movePlayer
call delay
push 0
push -2
call movePlayer
call delay
push 0
push -3
call movePlayer
call delay
push 0
push -4
call movePlayer

call delay
call delay
call delay


push 0
push 0
call movePlayer
call delay
push 0
push 1
call movePlayer
call delay
push 0
push 2
call movePlayer
call delay
push 0
push 3
call movePlayer
call delay
push 0
push 4
call movePlayer
call delay
call delay
ret
;===================================JUMP FUNCTION END================================



;=======================================PLAYER CODE END==========================


;Same code as Create object but instead of creating pixel, it uses the function isPlayerPixel(playercolor) <= player color is global variable on top
CheckCollision:
push bp
mov bp,sp
push ax
push bx
push cx
push dx
push si
push di

mov cx,0
mov si,0
mov di,0
;si = x,di = y
mov bx,[player_address]

complete_player_collide:
cmp si,10
jna y_coord_adjusted_collide
; adjust y coord here
sub si,11
add di,1
y_coord_adjusted_collide:
mov ax,[bx]
cmp al,0
je skip_pixel_collide
push 0x0000; para1
add si,[x_offset];x coord
add di,[y_offset];y coord
push si; para2
push di;para3
sub si,[x_offset]
sub di,[y_offset]
call isPlayerPixel
skip_pixel_collide:
add si,1
add bx,1
add cx,1
cmp cx,176
jne complete_player_collide



pop di
pop si
pop dx
pop cx
pop bx
pop ax
mov sp,bp
pop bp
ret


isPlayerPixel:
push bp
mov bp,sp
push es
push ax
push si
push bx
mov si,0
mov ax,0
mov bx,0

push 0xb800
pop es
mov ax,[bp+4]
mov si,80
mul si
add ax,[bp+6]
shl ax,1
mov si,ax
mov bx,[bp+8]

mov ax,[obj_pixel_color];collision pixel (can be 4)
cmp word [es:si],ax
jne skip

mov word [collided],1

skip:
pop bx
pop si
pop ax
pop es
mov sp,bp
pop bp
ret 6




;simple reading different keys
kbisr:
In ax, 0x60

;pushf
;call far [cs:OldIntVect]



cmp al,185
jne skip_space_code
call set_jump
skip_space_code:


cmp al,42
jne skip_shift_press
call ClearPlayer
mov word [player_address],player_duck
push word [x_offset]
push word [y_offset]
call CreatePlayer
skip_shift_press:


cmp al,170
jne skip_shift_release
call ClearPlayer
mov word [player_address],player
push word [x_offset]
push word [y_offset]
call CreatePlayer
skip_shift_release:




cmp al,144
jne skip_quit
mov word [end_prog_bool],1
skip_quit:


end_isr:
mov al, 0x20
out 0x20, al
iret


set_jump:
mov word [jump],1
ret


key_count: dw 0
kbisrVect: dw 0,0
end_prog_bool: dw 0
jump:dw 0

;+++++++++++++++++++++++++++++++++++++++++++++++++++++START PROGRAM++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
yourscore:      db   'SCORE:' 
Entry:

;Load Player
mov word [player_address],player


;Clear screen
clear_screen:
mov di,0
push es
push 0xb800
pop es
comp2:
mov word [es:di],0x0000
add di,2
cmp di,4000
jne comp2
pop es
           ;ya han par laoun
 mov  ah, 0x13           ; service 13 - print string               
mov  al, 1              ; subservice 01 – update cursor               
mov  bh, 0              ; output on page 0               
mov  bl, 6              ; normal attrib               
mov  dx, 0x022F         ; row 10 column 3               
mov  cx, 6             ; length of string               
push cs               
pop  es                 ; segment of string                
mov  bp, yourscore        ; offset of string                
int  0x10     

;Create player
push word [x_offset]
push word [y_offset]
call CreatePlayer







mov di,0
Install_timer_isr:
   push   ds
   xor    cx, cx
   mov    ds, cx
 
   mov    ax, [ds:8*4]
   mov    dx, [ds:8*4+2]
   cli
   mov    word [ds:8*4],InterruptHandler
   mov    [ds:8*4+2], cs
   pop    ds
   mov    word [OldIntVect], ax
   mov    word [OldIntVect+2], dx
   sti
  
Install_KeyBoard_isr:
   push   ds
   xor    cx, cx
   mov    ds, cx
 
   mov    ax, [ds:9*4]
   mov    dx, [ds:9*4+2]
   cli
   mov    word [ds:9*4],kbisr
   mov    [ds:9*4+2], cs
   pop    ds
   mov    word [kbisrVect], ax
   mov    word [kbisrVect+2], dx
   sti
  
 
;if end_prog_bool is 1(Changed by timer isr). Unhook interrupts and clear screen.
l1:
cmp word [end_prog_bool],1
je Start_end_Prog
cmp word [jump],1
jne l1
call jump_player
mov word [jump],0
jmp l1




 Start_end_Prog:
 push es
 push 0xb800
 pop es
 mov cx,1920
 mov di,0
 mov ax,0x0700
 rep stosw
 pop es

   Unhook_interrupt_Kbisr:

   mov    ax, word [kbisrVect]
   mov    dx, word [kbisrVect+2]
   push   ds
   xor    cx, cx
   mov    ds, cx
   cli
   mov    [ds:9*4], ax
   mov    [ds:9*4+2], dx
   sti
   pop    ds


   Unhook_interrupt_Timer:

   mov    ax, word [OldIntVect]
   mov    dx, word [OldIntVect+2]
   push   ds
   xor    cx, cx
   mov    ds, cx
   cli
   mov    [ds:8*4], ax
   mov    [ds:8*4+2], dx
   sti
   pop    ds
; Exit to DOS
 
end_Prog:
mov ax,0x4c00
int   21h
 
;++++++++++++++++++++++++++++++++++++++++++++++END PROGRAM++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


;=============================================Timer ISR START=========================================
InterruptHandler:
pushf
call far [cs:OldIntVect]
cmp word [busy],1
je ExitHandler
mov word [busy],1
call CheckCollision
cmp word [collided],1
je ExitHandler


call Delete_objects
call shift_objects
call Create_objects

push ax
add word [score],1
mov ax,[score]
call printax
pop ax

cmp word [score],100
jne skip_color_score_100
mov word [obj_pixel_color],0xb000
skip_color_score_100:


cmp word [score],300
jne skip_color_score_300
mov word [obj_pixel_color],0xd000
skip_color_score_300:


isr_routine_complete:
mov word [busy],0
ExitHandler:
iret
;=========================TIMER ISR END===================================



;==========================print score numbers============================
printax:
pushA
mov si,0
mov di,0

keep_dividing:
mov bx,0
mov dx,0
mov cx,10
div cx
add di,1
push dx
cmp ax,0
jne keep_dividing


keep_printing:
pop ax
mov ah,07h
add al,30h

push es
push 0xb800
pop es

mov bx,450
add bx,si
mov [es:bx],ax
add si,2
pop es
sub di,1
cmp di,0
jne keep_printing
popA
ret
;============================================Print score end==============================


block:dw 3998
OldIntVect: dd 0
busy:dw 0
time:dw 0