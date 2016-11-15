import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

class MidiInfoGenerator implements Runnable {

    private Track[] tracks;

    public Map<Track, Map<Integer, Integer>> channelCount = new ConcurrentHashMap<Track, Map<Integer,Integer>>();
    // Constructor
    MidiInfoGenerator(Track[] tracks) {
        this.tracks = tracks;
    }

    public void run() {
        try {
            ArrayList<MidiReader> midiInfo = new ArrayList<MidiReader>();
            ArrayList<Thread> threads = new ArrayList<Thread>();

            for(int i = 0; i < tracks.length; ++i) {
                MidiReader midi = new MidiReader(tracks[i], channelCount);
                midiInfo.add(midi);

                Thread thread = new Thread(midi);
                threads.add(thread);
                thread.start();
            }

            for(int i = 0; i < midiInfo.size(); ++i) {
                threads.get(i).join();
            }
        } catch(Exception e) {
            println(e);
            return;
        }
    }
}