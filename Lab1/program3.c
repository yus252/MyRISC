int main(){
   int tap_ptrn_index = 0;
   int best_index = 0;
   int max = 0;

   // decode + find the number of spaces
   for(int tap_ptrn_index = 0; tap_ptrn_index < 9; tap_ptrn_index++){
      byte try_state = mem[64] ^ 0x20;
      byte tap = TAP[tap_ptrn_index];

      int count = 0;
      while(mem[64+i] == try_state ^ 0x20){
         try_state = lfsr(tap, try_state);
         count+= 1;
      }

      if (max < count){
         max = count;
         best_index = tap_ptrn_index;
      }
   }

   byte tap = LUT[best_index];
   byte lfsr_state = mem[64] ^ space;

   int count = 0;
   while(mem[64+count] == lfsr_state ^ 0x20){
      lfsr_state = lfsr(taps, lfsr_state);
      count++;
   }
   
   // write encoded message
   for(int i = 0; i < (64 - count); i++){
      byte encrypted = mem[i + count +64];
      
      if(encrypted[7] == ^encrypted[6:0]) mem[i] = lfsr_state ^ encryted;
      else mem[i] = 0x80;

      lfsr_state = lfsr(tap, lfsr_state);
   }

   for(int i = (64 - count); i < 64; i++){
      mem[i] = 0x20;
   }

   return mem;
}
