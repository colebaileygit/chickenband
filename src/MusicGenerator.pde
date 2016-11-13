class MusicGenerator implements Runnable {

    private Track[] tracks;
    private Sound[] sounds;
    private int startTime;
    private int endTime;
    private float tickDuration;
    private int samplingRate;

    // Constructor
    MusicGenerator(Track[] tracks, Sound[] sounds, int startTime, int endTime, float tickDuration, int samplingRate) {
        this.tracks = tracks;
        this.sounds = sounds;
        this.startTime = startTime;
        this.endTime = endTime;
        this.tickDuration = tickDuration;
        this.samplingRate = samplingRate;
    }

    public void run() {
        try {
            ArrayList<TrackGenerator> trackGenerators = new ArrayList<TrackGenerator>();
            ArrayList<Thread> threads = new ArrayList<Thread>();

            for(int i = 0; i < tracks.length && i < sounds.length; ++i) {
                if(sounds[i] == null) continue; // Skip the track which we are not interested
                
                if (showDebugMessages) {
                    println(">>>  Track " + i + " is being generated.."); 
                }

                TrackGenerator trackGenerator = new TrackGenerator(tracks[i], sounds[i], startTime, endTime, tickDuration, samplingRate);
                trackGenerators.add(trackGenerator);

                Thread thread = new Thread(trackGenerator);
                threads.add(thread);
                thread.start();
            }

            for(int i = 0; i < trackGenerators.size(); ++i) {
                threads.get(i).join();
            }
        } catch(Exception e) {
            println(e);
            return;
        }
    }
}