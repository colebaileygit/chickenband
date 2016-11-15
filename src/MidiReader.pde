class MidiReader implements Runnable {

  private Track track; // MIDI track
  private Map<Track, Map<Integer, Integer>> channels;

  // Constructor
  MidiReader(Track track, Map<Track, Map<Integer, Integer>> channels) {
    this.track = track;
    this.channels = channels;
  }

  public void run() {
    // Read every MIDI event and handle all note on
    for (int i = 0; i < track.size(); ++i) {
      MidiEvent e = track.get(i);
      MidiMessage m = e.getMessage();
      if (m instanceof ShortMessage) { // Only ShortMessage are useful
        ShortMessage sm = (ShortMessage)(m);

        // Find all note on
        if (sm.getCommand() == ShortMessage.NOTE_ON && sm.getData2() != 0) {

          // Read the details of the note on command
          int channel = sm.getChannel();
          Map<Integer, Integer> map = channels.get(track);
          if (map!=null) {
            if (map.get(channel)!=null) {
              map.put(channel, map.get(channel)+1);
            } else {
              map = new HashMap<Integer, Integer>();
              map.put(channel, 1);
            }
          } else {
            map = new HashMap<Integer, Integer>();
            map.put(channel, 1);
            channels.put(track, map);
          }
        }
      }
    }
  }
}