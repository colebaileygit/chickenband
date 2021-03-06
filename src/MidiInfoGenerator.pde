import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

class MidiInfoGenerator implements Runnable {

  private Track[] tracks;

  public Map<Track, Map<Integer, Integer>> channelCount = new ConcurrentHashMap<Track, Map<Integer, Integer>>();
  public  Map<Track, Integer> instruments = new ConcurrentHashMap<Track, Integer>();

  // Constructor
  MidiInfoGenerator(Track[] tracks) {
    this.tracks = tracks;
    
    // set default instrument number to grand piano (0) for every track to avoid null pointer exception when instrument not specified.
    for (Track t : tracks) {
       instruments.put(t, 0); 
    }
  }

  public void run() {
    try {
      ArrayList<MidiReader> midiInfo = new ArrayList<MidiReader>();
      ArrayList<Thread> threads = new ArrayList<Thread>();

      for (int i = 0; i < tracks.length; ++i) {
        MidiReader midi = new MidiReader(tracks[i], channelCount, instruments);
        midiInfo.add(midi);

        Thread thread = new Thread(midi);
        threads.add(thread);
        thread.start();
      }

      for (int i = 0; i < midiInfo.size(); ++i) {
        threads.get(i).join();
      }
    } 
    catch(Exception e) {
      println(e);
      return;
    }
  }
}