int main(){
   int tap_ptrn_index = 0;
   int best_index = 0;
   int max = 0;
   int count = 0;
   for(int tap_ptrn_index = 0; tap_ptrn_index < 9; tap_ptrn_index ++){
      count = 0;
      byte try_state = mem[64] ^ space;
      byte taps = TAP[tap_ptrn_index];

      while(mem[64+count] == try_state ^ 0x20){
         try_state = lfsr(taps, try_state);
         count += 1;
      }
      if (max < count){
         max = count;
         best_index = tap_ptrn_index;
      }
   }

   byte taps = LUT[best_index];
   byte lfsr_state = mem[64] ^ space;
   count = 0;
   
   // find the number of spaces
   while(mem[64+count] == lfsr_state ^ 0x20){ 
      lfsr_state = lfsr(taps, lfsr_state);
      count++;
   }

   // write spaces
   for(int i = 0; i < count; i++){
      mem[i] = 0x20;
   }
   
   // write encoded message
   for(int i = count; i < 64; i++){
      byte encrypted = mem[i+64];
      
      if(encrypted[7] == ^encrypted[6:0]) mem[i] = lfsr_state ^ mem[i+64];
      else mem[i] = 0x80;

      lfsr_state = lfsr(taps, lfsr_state);
   }

   return mem;
}
