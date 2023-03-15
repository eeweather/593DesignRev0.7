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

short c_predictor (svBitVecVal a, svBitVecVal b, svBitVecVal* instruction, svBitVecVal* resultInput, char* agentName, svBitVecVal* calltime){
    short result = 0;
    int inst = 0;
    int addr = 0;
    int i;
    int x;
    static int firstRun = 0;
    static int mem[MEMSIZE];
    static int lastaddr = 0;
    static int lastinst = 0;
    static int lastagent = 4;
    static int lastcalltime = 0;
    int overWriteFlag = 0;
    //char agent[] = *agentName;
    int agentNum = 4; // initialize impossible number

    if(firstRun == 0){
        for (i=0; i<MEMSIZE; i++){
            mem[i]= i+1;
        }
        firstRun++;
    }



    //agentNum = agentName[0];
    //printf("agent name: %s size of agentname %d \n \n\n", agentName, sizeof(agentName));
    for(i = 0; i<strlen(agentName); i++){
        x = isdigit(agentName[i]);
        if(x!=0){
            agentNum = (agentName[i])-48;
            //printf("agent num: %d \n \n \n", agentNum);
           
        } 
        //printf("%c\n",agentName[i]);
       
    }

   

    inst = *instruction>>15;
    addr = (*instruction & 0b0000111111111111111)>>1;

    if(lastaddr == addr && inst == 0b1001 && lastinst == 0b1001 && lastagent>agentNum && (*calltime-lastcalltime == 20)){
        //overWriteFlag = 1;
    }

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
            //printf("load, agentnum: %d, mem[addr]: %x, addr: %d \n", agentNum, mem[addr], addr);
            switch(agentNum){
                case 3:
                case 2:
                case 1:
                case 0: result = 0x00FF & (mem[addr]); 
            }
            break;
        case 0b1001:
            //printf("store, agentnum: %d, resultInput: %x, addr: %d, lastinst: %d,\n inst: %d, lastagent: %d, lastaddr: %d, owf: %d \n calltime: %d last call time: %d\n", agentNum, *resultInput, addr, lastinst, inst, lastagent, lastaddr, overWriteFlag, *calltime, lastcalltime);
            //printf("store, agentnum: %d, resultInput: %x, addr: %d \n", agentNum, *resultInput, addr);
            if(!overWriteFlag){
            switch(agentNum){
                case 3:
                case 2:
                case 1:
                case 0:  mem[addr] = *resultInput; 
            }}
            break;
    }
    lastaddr = addr;
    lastagent = agentNum;
    lastinst = inst;
    lastcalltime = *calltime;
    return result;
}
