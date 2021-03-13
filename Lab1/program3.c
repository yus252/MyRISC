int main(){
   int tap_ptrn_index = 0;
   int best_index = 0;
   int best_tap = 0;
   for(int tap_ptrn_index = 0; tap_ptrn_index < 9; tap_ptrn_index ++){
      int i = 0;
      byte try_state = mem[64] ^ space;
      byte taps = TAP[tap_ptrn_index];

      while(mem[64+i] == try_state ^ 0x20){
         try_state = {try_state[5:0],^(taps&try_state)};
         i += 1;
      }
      i = i-1;
      if (best_tap < i){
         best_tap = i;
         best_index = tap_ptrn_index;
      }
   }

   byte taps = LUT[best_index];

   // Top from program 2


   byte lfsr_state = mem[64] ^ space;
   int i = 0;
   while(mem[64+i] == lfsr_state ^ 0x20){ // rememeber to remove top bit
      lfsr_state = {lfsr_state[5:0],^(taps&lfsr_state)};
      i += 1;
   }

   // i will be pointing to first non space
   cnt = 64 - i;

   for(int j = 0; j < cnt; j++){
      byte encrypted = mem[64+i+j];
      //0b1000000
      if (encrypted[7] == rxor(encrpted[6:0])){
         mem[j] = lfsr_state ^ mem[64+i+j];
      } else{
         mem[j] = 0x80;
      }

      lfsr_state = {lfsr_state[5:0],^(taps&lfsr_state)};
   }

   for(int i = cnt; i < 64;i++){
      mem[i] = 0x20;
   }

   return 0;
}
