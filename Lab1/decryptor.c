#include <stdio.h>

unsigned char getBit(unsigned char n, unsigned int k){
    return (n & ( 1 << k )) >> k;
}

unsigned char setBit(unsigned char n, unsigned int p, unsigned int b) 
{ 
    unsigned int mask = 1 << p; 
    return (n & ~mask) | ((b << p) & mask); 
}

unsigned char lfsr(unsigned char tap, unsigned char state){
    if(tap > 0x08) tap = tap & 0x07;

    if(tap == 0x00) tap = getBit(state, 6) ^ getBit(state,5);
    else if(tap == 0x01) tap = getBit(state, 6) ^ getBit(state, 3);
    else if(tap == 0x02) tap = getBit(state, 6) ^ getBit(state, 5) ^ 
        getBit(state, 4) ^ getBit(state, 3);
    else if(tap == 0x03) tap = getBit(state, 6) ^ getBit(state, 5) ^ 
        getBit(state, 4) ^ getBit(state, 1); 
    else if(tap == 0x04) tap = getBit(state, 6) ^ getBit(state, 5) ^ 
        getBit(state, 3) ^ getBit(state, 1); 
    else if(tap == 0x05) tap = getBit(state, 6) ^ getBit(state, 5) ^ 
        getBit(state, 3) ^ getBit(state, 0); 
    else if(tap == 0x06) tap = getBit(state, 6) ^ getBit(state, 4) ^ 
        getBit(state, 3) ^ getBit(state, 2); 
    else if(tap == 0x07) tap = getBit(state, 6) ^ getBit(state, 5) ^ 
        getBit(state, 4) ^ getBit(state, 3) ^
            getBit(state, 2) ^ getBit(state, 1); 
    else if(tap == 0x08) tap = getBit(state, 6) ^ getBit(state, 5) ^ 
        getBit(state, 4) ^ getBit(state, 3) ^
            getBit(state, 1) ^ getBit(state, 0);  

    state = state << 1;   
    setBit(state, 0, (unsigned int) tap);
    return state;
}

char * decryptor(char * mem){

    // STEP 1

    // 127 possible initial seeds, 9 tap patterns (0x00..0x08)
    // mem[64]..mem[73] = 0x20 

    unsigned char tap = 0x00;  // default tap sequence
    unsigned char seed = 0x01; // default starting state
    unsigned char state = seed;   

    int count = 0;
    // find a seed that decrypts 10 space chars 
    while(count < 10){
        state = lfsr(tap, state);
        // advance if a space char was decrypted
        if((mem[64+count] ^ state) == 0x20){
            count++;
        }
        // otherwise, start over with a new seed
        else{
            count = 0;
            // if we have checked every seed for this tap, 
            // try the next tap pattern 
            if(seed == 127){
                tap++;
                seed = 0x01;
            }
            else{
                seed++;
            }
            state = seed;
        }
    }
    // if we reach here, we have found the right tap/seed pair! 
    // (stored in tap, seed)

    // STEP 2 
    // decrypt the message with the found tap pattern / seed 
    state = seed;
    for(count = 0; count < 64; count++){
        state = lfsr(tap, state);
        mem[count] = mem[count+64] ^ state;
    }

    return mem;
}
