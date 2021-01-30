#include <stdio.h>

// reused from encrypter.c
unsigned char lfsr(unsigned char tap, unsigned char seed){
    unsigned char next = seed << 1;    
    setBit(next, 0, (unsigned int) tap);
    return next;
}

char * decryptor(char * mem){
	
	// STEP 1
	
	// 127 possible initial seeds, 9 tap patterns (0x00..0x08)
	// mem[64]..mem[73] = 0x20 
	
	unsigned char tap = 0x00;  // default tap sequence
	unsigned char seed = 0x01; // default starting state
	unsigned char state = seed;   
	    
    if(tap > 0x08) tap = tap & 0x07;

    if(tap == 0x00) tap = getBit(seed, 6) ^ getBit(seed,5);
    else if(tap == 0x01) tap = getBit(seed, 6) ^ getBit(seed, 3);
    else if(tap == 0x02) tap = getBit(seed, 6) ^ getBit(seed, 5) ^ 
                                 getBit(seed, 4) ^ getBit(seed, 3);
    else if(tap == 0x03) tap = getBit(seed, 6) ^ getBit(seed, 5) ^ 
                                 getBit(seed, 4) ^ getBit(seed, 1); 
    else if(tap == 0x04) tap = getBit(seed, 6) ^ getBit(seed, 5) ^ 
                                 getBit(seed, 3) ^ getBit(seed, 1); 
    else if(tap == 0x05) tap = getBit(seed, 6) ^ getBit(seed, 5) ^ 
                                 getBit(seed, 3) ^ getBit(seed, 0); 
    else if(tap == 0x06) tap = getBit(seed, 6) ^ getBit(seed, 4) ^ 
                                 getBit(seed, 3) ^ getBit(seed, 2); 
    else if(tap == 0x07) tap = getBit(seed, 6) ^ getBit(seed, 5) ^ 
                                 getBit(seed, 4) ^ getBit(seed, 3) ^
                                 getBit(seed, 2) ^ getBit(seed, 1); 
    else if(tap == 0x08) tap = getBit(seed, 6) ^ getBit(seed, 5) ^ 
                                 getBit(seed, 4) ^ getBit(seed, 3) ^
                                 getBit(seed, 1) ^ getBit(seed, 0); 
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
