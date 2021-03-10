#include <stdio.h>

char * decryptor(char * mem){

    // STEP 1

    // 127 possible initial seeds, 9 tap patterns (0x00..0x08)
    // mem[64]..mem[73] = 0x20 

	int[9] LUT = {[6,5],[6,4,3]....}; // LUT of tap sequences 
	
    unsigned char tap_index = 0x00;  // default tap index
	unsigned char seed = 0x01; // default starting state
    unsigned char state = seed;   

    int count = 0;
    // find a seed that decrypts 10 space chars 
    while(count < 10){
        tap = LUT[tap_index];
        next_state = (state << 1) | ^(tap & state);
		
		// advance if a space char was decrypted
        if((mem[64+count] ^ state) == 0x20){
            count++;
			state = next_state;
        }
        // otherwise, start over with a new seed
        else{
            count = 0;
            // try the next seed  
            if(seed < 127){
                seed++;
            }
			// if we have tried every seed for this tap, 
            // try the next tap pattern
            else{
                tap++;
                seed = 0x01;
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
        next_state = (state << 1) | ^(tap & state);
        mem[count] = mem[count+64] ^ state;
		state = next_state;
    }

    return mem;
}
