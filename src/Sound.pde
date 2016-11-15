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
    public float getFundamentalFrequency() { return getFundamentalFrequency(0f); }
    public float getFundamentalFrequency(float frequency) { return fundamentalFrequency; }
    public float getRelativeVolume() { return getRelativeVolume(0f); }
    public float getRelativeVolume(float frequency) { return relativeVolume; }
    public float getStereoPosition() { return stereoPosition; }
    public String getFilepath() { return getFilepath(0f); }
    public String getFilepath(float frequency) { return filepath; }
    public float getFactor(float desiredFrequency) {
       return fundamentalFrequency / desiredFrequency; 
    }
     
}

// add relevant metadata for each sound 'int' here.
static class SoundDataMappings {
   public static final int PIANO = 1;
   public static final int GUITAR = 2;
   public static final int BASS = 3;
   public static final int BRASS = 4;
   
   
   
   public static int[] postprocessingMapping(int id) {
     switch (id) {
         case PIANO: return new int[] { 2 }; 
         default: return new int[] { 2 }; 
     }
       
    }
    
    public static float frequencyMapping(int id) {
      switch (id) {
         case PIANO: return 525f;
         default: return 525f;
      }
    }
    
    public static String filepathMapping(int id) {
        switch (id) {
           case PIANO: return "../chickenband/res/sounds/eC1.wav";
           //case GUITAR:...
           default: return "../chickenband/res/sounds/eC1.wav";
        }
    } 
}