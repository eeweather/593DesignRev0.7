/*  ECE593 Project 2023wi
*   Victoria Van Gaasbeck <vvan@pdx.edu>
*   Julia Filipchuk <bfilipc2@pdx.edu>
*   Emily Weatherford <ew22@pdx.edu>
*   Daniel Keller <dk27@pdx.edu>
*  
*  C predictor function for TinyALU scoreboard
*/
#include <stdio.h>
#include <stdlib.h>
#include "svdpi.h"


short predictor (svBitVecVal a, svBitVecVal b, svBitVecVal* op_set){
    short result = 1;
   
   switch (*op_set){
        case  1 :
            result = a + b; 
            break;
        case 2: 
            result = a & b;
             break;
        case 3: 
            result = a ^ b; 
            break;
        case 4:
            result = a * b; 
            break;
    }

    return result;
}