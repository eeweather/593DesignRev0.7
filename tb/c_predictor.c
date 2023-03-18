/*  ECE593 Project 2023wi
*   Victoria Van Gaasbeck <vvan@pdx.edu>
*   Julia Filipchuk <bfilipc2@pdx.edu>
*   Emily Weatherford <ew22@pdx.edu>
*   Daniel Keller <dk27@pdx.edu>
*  
*  C predictor function for final project
needs to:
intake actual instruction, actual a, actual b, return predicted result 
*/
#include <stdio.h>
#include <ctype.h>
#include <stdlib.h>
#include "svdpi.h"

#define MEMSIZE 16*1024

short c_predictor (svBitVecVal a, svBitVecVal b, svBitVecVal* instruction, svBitVecVal* resultInput, svBitVecVal* mem_data){
    
    short result = 0;
    int inst = 0;
    int addr = 0;
    int i;
    int x;
    static int firstRun = 0;
    static int mem[MEMSIZE];

    if(firstRun == 0){
        for (i=0; i<MEMSIZE; i++){
            mem[i]= i+1;
        }
        firstRun++;
    }

    inst = *instruction>>15;
    addr = (*instruction & 0b0000111111111111111)>>1;

   switch (inst){
        case 0b0001:
            result = a + b; 
            break;
        case 0b0010: 
            result = a & b;
             break;
        case 0b0011: 
            result = a ^ b; 
            break;
        case 0b0100:
            result = a * b; 
            break;
        case 0b0101:
            result = a + 2 * b; 
            break;
        case 0b0110:
            result = a * 2; 
            break;
        case 0b0111:
            result = a * 3; 
            break;
        case 0b1010:
            result = a<<3; 
            break;
        case 0b1011:
            result = a>>3; 
            break;
        case 0b1000:         
            result = 0x00FF & (mem[addr]);      
            break;
        case 0b1001:
                if(*mem_data!=*resultInput){
                    result = -1;
                }
                mem[addr] = *resultInput; 
            break;
    }

    return result;
}
