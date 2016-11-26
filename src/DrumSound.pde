class DrumSound extends Sound {
  
    public DrumSound() {
       super(SoundDataMappings.DRUMS); 
    }
    
    @Override
    public int[] getPostProcessingEffects() { return SoundDataMappings.postprocessingMapping(SoundDataMappings.DRUMS); }
    @Override
    public float getFundamentalFrequency(float frequency) { return frequency; }
    @Override
    public String getFilepath(float frequency) { 
      return SoundDataMappings.filepathMapping(determineDrum(frequency));
    }
    @Override
    public float getFactor(float desiredFrequency) {
       return 1f; 
    }
    
    private int determineDrum(float frequency) {
        int pitch = frequencyToPitch(frequency);
     //   println("pitch" + pitch);
        
        switch (pitch) {
           case 35:
           case 36: return SoundDataMappings.KICK_DRUM;
           case 37: case 39:
           case 38: return SoundDataMappings.SNARE_DRUM;
           case 44: case 46: case 51: case 53: case 54: case 56: case 59:
           case 42: return SoundDataMappings.HI_HAT;
           case 52: case 55:
           case 49: return SoundDataMappings.CRASH;
        }
        
        return SoundDataMappings.DRUMS;
    }
    
    private boolean compareToMIDIPitch(int MIDIPitch, float frequency) {
      
        int baseMIDIPitch = 21;
        float baseFrequency = 27.5;
        
        int pitchDelta = MIDIPitch - baseMIDIPitch;
        float pitchFrequency = baseFrequency * pow(2, float(pitchDelta) / 12);

        return abs(frequency - pitchFrequency) < 1E-5;
    }
    
    private int frequencyToPitch(float frequency) {
        int baseMIDIPitch = 21;
        float baseFrequency = 27.5;
        
        float exponent = log(frequency / baseFrequency);
        
        return round(exponent + baseMIDIPitch);
    }
}