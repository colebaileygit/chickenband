class Sound {
    private int id;
    private int[] ppEffects;
    private float fundamentalFrequency;
    private float relativeVolume;
    private String filepath;
    
    public Sound(int id) {
        this(id, 1.0);
    }
    
    public Sound(int id, float vol) {
       this(id, SoundDataMappings.postprocessingMapping(id), 
       SoundDataMappings.frequencyMapping(id), vol, 
       SoundDataMappings.filepathMapping(id));
    }
    
    public Sound(int id, int[] ppEffects, float freq, float vol, String path) {
       this.id = id;
       this.ppEffects = ppEffects;
       this.fundamentalFrequency = freq;
       this.relativeVolume = vol;
       this.filepath = path;
    }
    
    public int getId() { return id; }
    public int[] getPostProcessingEffects() { return ppEffects; }
    public float getFundamentalFrequency() { return fundamentalFrequency; }
    public float getRelativeVolume() { return relativeVolume; }
    public String getFilepath() { return filepath; }
    public float getFactor(float desiredFrequency) {
       return fundamentalFrequency / desiredFrequency; 
    }
     
}

static class SoundDataMappings {
   public static int[] postprocessingMapping(int id) {
       return new int[] { 0 }; 
    }
    
    public static float frequencyMapping(int id) {
       return 256f; 
    }
    
    public static String filepathMapping(int id) {
       return "../chickenband/src/sounds/C1.wav"; 
    } 
}