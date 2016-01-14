	.data
rows:	.word	0
dec:	.word	0
precis:	.word	0
strprm:	.ascii	"\nThis program will create a table that shows s minimum, a "
	.ascii	"maximum, and and e number of\nevenly separated sub values "
	.ascii	"inbetween dictated by the number of rows in the first column."
	.ascii	"\nIn the other column will be the value of the function f(x)="
	.ascii	"(5x^3-3x^2+2x+20)/11 with each\nvalue in the first column "
	.asciz	"being used as the x value for the second column.\n\n"
	.align	2
strmin:	.asciz	"Input the minimum value in the table:\n"
	.align	2
strmax:	.asciz	"Input the maximum value in the table:\n"
	.align	2
strrow:	.asciz	"Input the number of rows to be in the table:\n"
	.align	2
strdec:	.asciz	"Input the number of decimal places to show in each number:\n"
	.align	2
strprc:	.asciz	"Input the number of decimal places to use in each number:\n"
	.align	2
strfr1:	.asciz	"%d"
	.align	2
strfr2:	.asciz	"%s"
	.align	2
newlin:	.asciz	"\n"
	.align	2
space:	.asciz	" | "
	.align	2
space1:	.asciz	"               | "
	.align	2
xcol:	.asciz	" xvalues "
	.align	2
ycol:	.asciz	" f(x)values"
	.align	2
min:	.skip	16
max:	.skip	16


	.text
	.global main

	@@This function performs the f(x) = (5x^3 - 3x^2 +2x +20)/11
	@@with x in r4 and no other input.

f:	stmfd	sp!, {r5-r10,lr}
	mov	r2, r4			@@This line Loads in the current x value

	smull	r0, r1, r2, r4
	ldr	r6, =precis
	ldr	r6, [r6]		@@This loads in my precision for shifting
	rsb	r7, r6, #32		@@multi line number
	lsr	r0, r0, r6
	lsl	r1, r1, r7
	orr	r2, r0, r1

	smull	r0, r1, r2, r4		@@This block functions as above but squares
	lsr	r0, r0, r6		@@instead of cubing.
	lsl	r1, r1, r7
	orr	r3, r0, r1

	mov	r0, #5			@@This block performs my coefficient multiplies
	mul	r3, r3, r0
	mov	r0, #-3
	mul	r2, r2, r0
	mov	r0, #2
	mul	r1, r4, r0
	mov	r0, #20

	lsl	r0, r0, r6		@@This block adds the numbers together
	add	r0, r1, r0
	add	r0, r0, r2
	add	r0, r0, r3

	mov	r1, #11			@@Use provided function to divide by 11
	bl	sdiv32

	ldmfd	sp!, {r5-r10,lr}
	mov	pc, lr

	@@The main function starts here.
main:	stmfd	sp!, {r4-r10,lr}

	ldr	r0, =strprm		@@This is my main promt which explains how 
	bl	printf			@@the whole program works.

	ldr	r0, =strprc		@@The next 7 blocks read in all needed values,
	bl	printf			@@and translate from string to int where needed.
	ldr	r0, =strfr1		@@Each block's promt string shows what it is reading.
	ldr	r1, =precis
	bl	scanf

	ldr	r0, =strmin
	bl	printf
	ldr	r0, =strfr2
	ldr	r1, =min
	bl	scanf

	ldr	r0, =min
	ldr	r1, =precis
	ldr	r1, [r1]
	bl	strtoSfixed
	mov	r4, r0

	ldr	r0, =strmax
	bl	printf
	ldr	r0, =strfr2
	ldr	r1, =max
	bl	scanf

	ldr	r0, =max
	ldr	r1, =precis
	ldr	r1, [r1]
	bl	strtoSfixed
	mov	r5, r0

	ldr	r0, =strrow
	bl	printf
	ldr	r0, =strfr1
	ldr	r1, =rows
	bl	scanf

	ldr	r0, =strdec
	bl	printf
	ldr	r0, =strfr1
	ldr	r1, =dec
	bl	scanf

	sub	r6, r5, r4		@@This line if finding the range from min to max

	ldr	r8, =rows
	ldr	r8, [r8]

	mov	r0, r6			@@This take the number of rows in r8 and divides
	sub	r1, r8, #1		@@the range by it to find the step x changes by.
	bl	sdiv32

	mov	r9, r0

	ldr	r0, =xcol		@@These lines print the headers for my table and then
	bl	printf			@@a new line.
	ldr	r0, =ycol
	bl	printf
	ldr	r0, =newlin
	bl	printf

	mov	r7, #0
tblprt:	sub	r6, r8, #1		@@my first x is just min so i only canculate rows - 1
					@@x values.
	cmp	r7, r6			@@r7 is the loop counter for tblprt
	moveq	r0, r5			@@This tells it to print a calculated x or max if
	movne	r0, r4			@@it is my last time through the loop.

	ldr	r1, =precis		@@This block prints the x value
	ldr	r1, [r1]
	ldr	r2, =dec
	ldr	r2, [r2]
	bl	printS

	ldr	r0, =space		@@This prints the line between the columns of the table
	bl	printf

	add	r7, r7, #1
	bl	f

	ldr	r1, =precis		@@This block prints the f(x) value
	ldr	r1, [r1]
	ldr	r2, =dec
	ldr	r2, [r2]
	bl	printS

	ldr	r0, =newlin		@@This block prints a new line and checks if it must
	bl	printf			@@loop again.
	add	r4, r4, r9
	cmp	r7, r8
	bne	tblprt

	ldmfd	sp!, {r4-r10,lr}
	mov	pc, lr
