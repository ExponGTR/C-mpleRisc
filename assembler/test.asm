;test comment
mov r0, 0
mov r1, 10
mov r2, 20


add r3, r1, r2
cmp r3, 30
beq .mem_test
mov r10, 0xDEAD

.mem_test:
st r3, 64[r0]
ld r4, 64[r0]

call .subroutine
add r7, r0, 500

cmp r4, r3
beq .success

.subroutine:
lsl r5, r4, 2
ret

.success:
mov r15, 0x600D
.loop:
b .loop