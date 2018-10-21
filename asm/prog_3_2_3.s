_start:
    seti    r0, #0
    invoke  4, 0, 0
    invoke  1, 0, 0
    invoke  1, 0, 0
    invoke  1, 0, 0
    invoke  1, 0, 0
    invoke  2, 0, 0
    invoke  2, 0, 0
loop:
    invoke  11, 1, 0
    goto_ne end, r1, r0
    invoke  1, 0, 0
    goto    loop
end:
    stop    