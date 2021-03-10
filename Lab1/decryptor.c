#include <stdio.h>

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
        
        next_state = (state << 1) | ^(tap & state);
		
		// advance if a space char was decrypted
        if((mem[64+count] ^ state) == 0x20){
            count++;
			state = next_state;
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
        next_state = (state << 1) | ^(tap & state);
        mem[count] = mem[count+64] ^ state;
		state = next_state;
    }

    return mem;
}
