# SCHOOL_PROJECT_Assembly_Practice
Several subroutines to practice Assembly in TI MSP430

## bubble_sort.asm
It contains a subroutine for bubble sort an array. The unsorted array is stored in a certain memeory space, where the first element is the size of the array. The address of the array must be stored in register 6 (R6) before calling the subroutine. The sort happens in place.

## Remove_duplicate.asm
Given an array with duplicated elements (e.g. stored at address 0x0200), create a new array (e.g. stored at address 0x0214) that removes all the duplicated items. This code can run directly on MSP430.

## MULT_DIV.asm
Two subroutines here: MULT for multiplication of values in R4 and R5 (R4 * R5) and store the product at address 0x020A; DIV for division of values in R6 and R5 (R6 / R5) and store the quotient at address 0x021F. This code can be run directly on MSP430 with some test cases already provided.

## factorial.asm
It contains a subroutine to perform factorial (n!) on a given integer (n). The integer must be in R5 and the result is stored in R6. A MULT subroutine is called inside factorial subroutine.
