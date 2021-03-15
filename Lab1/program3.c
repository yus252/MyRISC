int main(){
   int best_index = 0;
   int max = 0;
   byte try_state = mem[64] ^ 0x20;
   byte lfsr_state = 0;
   
   // decode + find the number of spaces
   for(int tap_ptrn_index = 0; tap_ptrn_index < 9; tap_ptrn_index++){
      byte tap = TAP[tap_ptrn_index];

      int count= 0;
      while(mem[64 + count][6:0] == try_state[6:0] ^ 0x20){
         try_state = lfsr(tap, try_state);
         count+= 1;
      }

      if (max < count){
         max = count;
         best_index = tap_ptrn_index;
         lfsr_state = try_state
      }
   }

   byte tap = LUT[best_index];
   
   // write encoded message
   for(int i = 0; i < (64 - max); i++){
      byte encrypted = mem[i+max+64];
      
      if(encrypted[7] == ^encrypted[6:0]) mem[i] = lfsr_state ^ encryted[6:0];
      else mem[i] = 0x80;

      lfsr_state = lfsr(tap, lfsr_state);
   }

   return mem;
}
