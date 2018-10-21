_start:
    seti    r0, #0
    seti    r1, #5
    seti    r2, #1
    invoke 2, 0, 0
    invoke 2, 0, 0
loop:
    goto_eq end, r0, r1
    invoke  1, 0, 0
    add     r0, r0, r2
    goto    loop
end:
    stop    