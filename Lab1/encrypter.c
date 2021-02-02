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

char * encrypter(char * mem){
    int i;
    int count;
    unsigned char b;

    // step 2
    count = mem[61];

    // step 3

    if(count < 10) count = 10;
    else if(count > 26) count = 26;

    // lfsr
    unsigned char tap = mem[62];
    unsigned char state = mem[63];


    // step 4
    for(i = 0; i < count; i++){
        state = lfsr(tap, state);
        mem[64 + i] = 0x20 ^ state;
    }

    // step 5
    for(i = 64 + count; i < 128; i++){
        state = lfsr(tap, state);
        mem[i] = state ^ mem[ i - (64 + count)];
    }    

    //step 6
    for(i = 64; i< 128; i++){
        b = mem[i];
        mem[i] = setBit(b, 7,  getBit(b,0)^getBit(b,1)^getBit(b,2)^getBit(b,3)^
                getBit(b,4)^getBit(b,5)^getBit(b,6));
    }

    return mem;
}


int main()
{
    char * mem = "ABCDEFG";
    encrypter(mem);
}
