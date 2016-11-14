class Sound {
    private int id;
    private int[] ppEffects;
    private float fundamentalFrequency;
    private float relativeVolume;
    private float stereoPosition;
    private String filepath;
    
    public Sound(int id) {
        this(id, 1.0);
    }
    
    public Sound(int id, float vol) {
        this(id, vol, 0.5);
    }
    
    public Sound(int id, float vol, float stereoPosition) {
        this(id, SoundDataMappings.postprocessingMapping(id), 
             SoundDataMappings.frequencyMapping(id), vol, stereoPosition,
             SoundDataMappings.filepathMapping(id));
    }
    
    public Sound(int id, int[] ppEffects, float freq, float vol, float stereoPosition, String path) {
       this.id = id;
       this.ppEffects = ppEffects;
       this.fundamentalFrequency = freq;
       this.relativeVolume = vol;
       this.stereoPosition = stereoPosition;
       this.filepath = path;
    }
    
    public int getId() { return id; }
    public int[] getPostProcessingEffects() { return ppEffects; }
    public float getFundamentalFrequency() { return fundamentalFrequency; }
    public float getRelativeVolume() { return relativeVolume; }
    public float getStereoPosition() { return stereoPosition; }
    public String getFilepath() { return filepath; }
    public float getFactor(float desiredFrequency) {
       return fundamentalFrequency / desiredFrequency; 
    }
     
}

// add relevant metadata for each sound 'int' here.
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