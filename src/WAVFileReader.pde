import com.musicg.wave.*;

class WavFileReader {
    String filename;
    Wave wave;
    
    WavFileReader(String filename) {
       this.filename = filename; 
       this.wave = new Wave(filename);
    }
    
    float[] getData() {
       short[] samples = wave.getSampleAmplitudes();
       float[] result = new float[samples.length];
       // perform boost to reduce sound to [-1,1]
       float maxValue = Short.MIN_VALUE * -1f;
       
  //     println("Max value is " + maxValue);
       
       for (int i = 0; i < samples.length; i++) {
          result[i] = float(samples[i]) / maxValue; 
       }
       
       return result;
    }
  
}