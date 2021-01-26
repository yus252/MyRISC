#include <stdio.h>

unsigned char getBit(unsigned char n, unsigned int k){
    return (n & ( 1 << k )) >> k;
}

unsigned char setBit(unsigned char n, unsigned int p, unsigned int b) 
{ 
    unsigned int mask = 1 << p; 
    return (n & ~mask) | ((b << p) & mask); 
}

unsigned char lfsr(unsigned char tap_seq, unsigned char seed){
    unsigned char b = 0;
    unsigned char next = seed >> 1;   
    
    if(tap_seq > 0x08) tap_seq = tap_seq & 0x07;

    if(tap_seq == 0x00) b = getBit(seed, 6) ^ getBit(seed,5);
    else if(tap_seq == 0x01) b = getBit(seed, 6) ^ getBit(seed, 3);
    else if(tap_seq == 0x02) b = getBit(seed, 6) ^ getBit(seed, 5) ^ 
                                 getBit(seed, 4) ^ getBit(seed, 3);
    else if(tap_seq == 0x03) b = getBit(seed, 6) ^ getBit(seed, 5) ^ 
                                 getBit(seed, 4) ^ getBit(seed, 1); 
    else if(tap_seq == 0x04) b = getBit(seed, 6) ^ getBit(seed, 5) ^ 
                                 getBit(seed, 3) ^ getBit(seed, 1); 
    else if(tap_seq == 0x05) b = getBit(seed, 6) ^ getBit(seed, 5) ^ 
                                 getBit(seed, 3) ^ getBit(seed, 0); 
    else if(tap_seq == 0x06) b = getBit(seed, 6) ^ getBit(seed, 4) ^ 
                                 getBit(seed, 3) ^ getBit(seed, 2); 
    else if(tap_seq == 0x07) b = getBit(seed, 6) ^ getBit(seed, 5) ^ 
                                 getBit(seed, 4) ^ getBit(seed, 3) ^
                                 getBit(seed, 2) ^ getBit(seed, 1); 
    else if(tap_seq == 0x08) b = getBit(seed, 6) ^ getBit(seed, 5) ^ 
                                 getBit(seed, 4) ^ getBit(seed, 3) ^
                                 getBit(seed, 1) ^ getBit(seed, 0); 
    
    setBit(next, 0, (unsigned int) b);
    return next;
}

char * encrypter(char * mem){
    int i;
    int count;
    unsigned char b;

    // step 2
    count = mem[61];
   
    // step 3
    unsigned char tap = mem[62];
    unsigned char state = mem[63];

    if(count < 10) count = 10;
    else if(count > 26) count = 26;
   
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
    for(i = 64 + count; i< 128; i++){
        b = mem[i];
        mem[i] = setBit(b, 7,  getBit(b,0)^getBit(b,1)^getBit(b,2)^getBit(b,3)^
            getBit(b,4)^getBit(b,5)^getBit(b,6));
    }

    return mem;
}


int main()
{
    char * mem = 0xffffffff;
    encrypter(mem);
}
