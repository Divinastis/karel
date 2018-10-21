_start:
    seti    r0, #0
    goto loop

left:
    invoke  2, 0, 0
    invoke  1, 0, 0
    invoke  11, 1, 0
    goto_ne end, r1, r0
    invoke  2, 0, 0
    goto loope
right:
    invoke  2 ,0, 0
    invoke  2 ,0, 0
    invoke  2 ,0, 0
    invoke  1, 0, 0
    invoke  11, 1, 0
    goto_ne end, r1, r0
    invoke  2 ,0, 0
    invoke  2 ,0, 0
    invoke  2 ,0, 0
    goto loop
loop:
    invoke  11, 1, 0
    goto_ne end, r1, r0
    invoke  5, 1, 2
    goto_eq left, r0, r2
    invoke  1, 0, 0
    goto    loop
loope:
    invoke  11, 1, 0
    goto_ne end, r1, r0
    invoke  5, 1, 2
    goto_eq right, r0, r2
    invoke  1, 0, 0
    goto    loope
end:
    stop