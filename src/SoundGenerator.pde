class SoundGenerator implements Runnable {
    private int samplingRate = 44100; // Number of samples used for 1 second of sound
    private int nyquistFrequency = samplingRate / 2; // Nyquist frequency

    private AudioSamples soundSamples;   // the sound samples (two channels)
    private int sound;
    private float amplitude = 1.0;
    private float frequency = 256;
    private float duration = 5;  // the duration of the sound to be generated (in seconds)

    private float minValue = -1.0;
    private float maxValue = 1.0;

    // Constructors
    SoundGenerator(int sound, float amplitude, float frequency, float duration, int samplingRate) {
        this.samplingRate = samplingRate;
        this.nyquistFrequency = samplingRate / 2;
        this.sound = sound;
        this.amplitude = amplitude;
        this.frequency = frequency;
        this.duration = duration;
        soundSamples = new AudioSamples(duration, samplingRate);
    }

    SoundGenerator(int sound, float amplitude, float frequency, float duration) {
        this.sound = sound;
        this.amplitude = amplitude;
        this.frequency = frequency;
        this.duration = duration;
        soundSamples = new AudioSamples(duration, samplingRate);
    }

    SoundGenerator(int sound, float amplitude, float frequency) {
        this.sound = sound;
        this.amplitude = amplitude;
        this.frequency = frequency;
        soundSamples = new AudioSamples(duration, samplingRate);
    }

    // This function is called when using thread
    public void run() {
        generateSound(sound, amplitude, frequency, duration);
    }

    // Setter and getter
    public void setSound(int sound) {
        this.sound = sound;
    }

    public int getSound() {
        return sound;
    }

    public void setAmp(float amplitude) {
        this.amplitude = amplitude;
    }

    public float getAmp() {
        return amplitude;
    }

    public void setFrequency(float frequency) {
        this.frequency = frequency;
    }

    public float getFrequency() {
        return frequency;
    }

    public AudioSamples getGeneratedSound() {
        return soundSamples;
    }

    // This function generates an individual sound, using the paramters passed into the constructor
    public AudioSamples generateSound() {
        return this.generateSound(sound, amplitude, frequency, duration);
    }

    public AudioSamples generateSound(int sound, float amplitude, float frequency) {
        return this.generateSound(sound, amplitude, frequency, duration);
    }

    // This function generates an individual sound
    public AudioSamples generateSound(int sound, float amplitude, float frequency, float duration) {
        // Reset audio samples before generating audio
        soundSamples.clear();

        switch(sound) {
            case (1): generateSineInTimeDomain(amplitude, frequency, duration); break;
            case (2): generateSquareInTimeDomain(amplitude, frequency, duration); break;
            case (3): generateSquareAdditiveSynthesis(amplitude, frequency, duration); break;
            case (4): generateSawtoothInTimeDomain(amplitude, frequency, duration); break;
            case (5): generateSawtoothAdditiveSynthesis(amplitude, frequency, duration); break;
            case (6): generateTriangleAdditiveSynthesis(amplitude, frequency, duration); break;
            case (7): generateBellFMSynthesis(amplitude, frequency, duration); break;
            case (8): generateKarplusStrongSound(amplitude, frequency, duration); break;
            case (9): generateWhiteNoise(amplitude, frequency, duration); break;
            case(10): generateFourSineWave(amplitude, frequency, duration); break;
            case(11): generateRepeatingNarrowPulse(amplitude, frequency, duration); break;
            case(12): generateTriangleInTimeDomain(amplitude, frequency, duration); break;
            case(13): generateSciFiSound(amplitude, frequency, duration); break;
            case(14): generateKarplusStrongSound2(amplitude, frequency, duration); break;
            case(15): generateAxB(1, 1, amplitude, frequency, duration); break;
            case(16): generateAxB(1, 5, amplitude, frequency, duration); break;
            case(17): generateAxB(1, 10, amplitude, frequency, duration); break;
            case(18): generateAxB(4, 4, amplitude, frequency, duration); break;
            case(19): generateAxB(5, 6, amplitude, frequency, duration); break;
            case(20): generateSound20(amplitude, frequency, duration); break; // You can add your own sound(s) if you want to
            case(21): generateSound21(amplitude, frequency, duration); break; // You can add your own sound(s) if you want to
            case(22): generateSound22(amplitude, frequency, duration); break; // You can add your own sound(s) if you want to
            case(23): generateSound23(amplitude, frequency, duration); break; // You can add your own sound(s) if you want to
            case(24): generateSound24(amplitude, frequency, duration); break; // You can add your own sound(s) if you want to
        }

        return soundSamples;
    }

    // This function generates a sine wave using the time domain method
    private void generateSineInTimeDomain(float amplitude, float frequency, float duration) {
        int samplesToGenerate = int(duration * samplingRate);
        for(int i = 0; i < samplesToGenerate && i < soundSamples.totalSamples; ++i) {
            float currentTime = float(i) / samplingRate;
            soundSamples.leftChannelSamples[i] = amplitude * sin(TWO_PI * frequency * currentTime);
            soundSamples.rightChannelSamples[i] = soundSamples.leftChannelSamples[i];
        }
    }

    // This function generates a square wave -_-_ using the time domain method
    private void generateSquareInTimeDomain(float amplitude, float frequency, float duration) {
        int samplesToGenerate = int(duration * samplingRate);
        float oneCycle = samplingRate / frequency;
        float halfCycle = oneCycle / 2;
        for(int i = 0; i < samplesToGenerate && i < soundSamples.totalSamples; ++i) {
            float whereInCycle = i % int(oneCycle);
            if (whereInCycle < halfCycle) {
                soundSamples.leftChannelSamples[i] = amplitude * maxValue;
                soundSamples.rightChannelSamples[i] = soundSamples.leftChannelSamples[i];
            } else {
                soundSamples.leftChannelSamples[i] = amplitude * minValue;
                soundSamples.rightChannelSamples[i] = soundSamples.leftChannelSamples[i];
            }
        }
    }

    // This function generates a square wave -_-_ using the additive synthesis method
    private void generateSquareAdditiveSynthesis(float amplitude, float frequency, float duration) {
        int samplesToGenerate = int(duration * samplingRate);

        for(int i = 0; i < samplesToGenerate && i < soundSamples.totalSamples; ++i) {
            float sampleValue = 0;
            float currentTime = float(i) / samplingRate;
            for(int wave = 1; wave * frequency < nyquistFrequency; wave += 2) {
                sampleValue += (1.0 / wave) * sin(wave * TWO_PI * frequency * currentTime);
            }
            soundSamples.leftChannelSamples[i] = amplitude * sampleValue;
            soundSamples.rightChannelSamples[i] = soundSamples.leftChannelSamples[i];
        }
    }

    // This function generates a sawtooth wave /|/| using time domain method
    private void generateSawtoothInTimeDomain(float amplitude, float frequency, float duration) {
        int samplesToGenerate = int(duration * samplingRate);
        float oneCycle = samplingRate / frequency;
        for(int i = 0; i < samplesToGenerate && i < soundSamples.totalSamples; ++i) {
            float sampleValue = int(i % oneCycle) / oneCycle * 2.0f - 1.0f;
            soundSamples.leftChannelSamples[i] = amplitude * sampleValue;
            soundSamples.rightChannelSamples[i] = soundSamples.leftChannelSamples[i];
        }
    }

    // This function generates a sawtooth wave \|\| using the additive synthesis method
    private void generateSawtoothAdditiveSynthesis(float amplitude, float frequency, float duration) {
        int samplesToGenerate = int(duration * samplingRate);
        for (int i = 0; i < samplesToGenerate; i++) {
            float currentTime = float(i) / samplingRate;
            float sampleValue = 0.0;
            for (int wave = 1; wave * frequency < nyquistFrequency; wave++) {
                sampleValue += ((1.0 / wave) * sin(TWO_PI * wave * frequency * currentTime));                
            }
            soundSamples.leftChannelSamples[i] = amplitude * sampleValue;
            soundSamples.rightChannelSamples[i] = soundSamples.leftChannelSamples[i];
        }
        
        soundSamples.postprocessEffect(2, 7, amplitude, 0);
    }

    // This function generates a triangle wave \/\/ using the additive synthesis method (with cosine)
    private void generateTriangleAdditiveSynthesis(float amplitude, float frequency, float duration) {
        int samplesToGenerate = int(duration * samplingRate);
        for (int i = 0; i < samplesToGenerate; i++) {
            float currentTime = float(i) / samplingRate;
            float sampleValue = 0.0;
            for (int wave = 1; wave * frequency < nyquistFrequency; wave += 2) {
                sampleValue += ((1.0 / (wave * wave)) * cos(TWO_PI * wave * frequency * currentTime));                
            }
            soundSamples.leftChannelSamples[i] = amplitude * sampleValue;
            soundSamples.rightChannelSamples[i] = soundSamples.leftChannelSamples[i];
        }
        
        soundSamples.postprocessEffect(2, 7, amplitude, 0);
    }

    // This function generates a 'bell' sound using FM synthesis
    private void generateBellFMSynthesis(float amplitude, float frequency, float duration) {
        int samplesToGenerate = int(duration * samplingRate);
        for (int i = 0; i < samplesToGenerate; i++) {
            float currentTime = float(i) / samplingRate;
            float sampleValue = amplitude * sin(TWO_PI * 100 * currentTime + 3.0 * sin(TWO_PI * 280 * currentTime));
            soundSamples.leftChannelSamples[i] = sampleValue;
            soundSamples.rightChannelSamples[i] = soundSamples.leftChannelSamples[i];
        }
        
        soundSamples.postprocessEffect(2, 7, amplitude, 0);
    }

    // This function generate a sound using Karplus-Strong algorithm
    private void generateKarplusStrongSound(float amplitude, float frequency, float duration) {
        // Fill array with 256Hz Sin wave
        generateWhiteNoise(amplitude, frequency, duration);
        
        // Apply KS Algorithm
        int samplesToGenerate = int(duration * samplingRate);
        int delaySamples = int(samplingRate / frequency);
        for (int i = delaySamples + 1; i < samplesToGenerate; i++) {
            float sampleValue = 0.5 * (soundSamples.leftChannelSamples[i - delaySamples] + soundSamples.leftChannelSamples[i - delaySamples - 1]); 
            soundSamples.leftChannelSamples[i] = sampleValue;
            soundSamples.rightChannelSamples[i] = soundSamples.leftChannelSamples[i];
        }
        
        soundSamples.postprocessEffect(2, 7, amplitude, 0);
    }

    // This function generats a white noise
    private void generateWhiteNoise(float amplitude, float frequency, float duration) {
        int samplesToGenerate = int(duration * samplingRate);
        for (int i = 0; i < samplesToGenerate; i++) {
            float sampleValue = random(minValue * amplitude, maxValue * amplitude);
            soundSamples.leftChannelSamples[i] = sampleValue;
            soundSamples.rightChannelSamples[i] = soundSamples.leftChannelSamples[i];
        }
    }

    // This function generates '3 sine wave' sound
    private void generateFourSineWave(float amplitude, float frequency, float duration) {
        // Generate the 3 sine waves by adding the sine waves at the correct frequency and
        // correct amplitude. The fundamental frequency comes from the variable 'frequency'.

        int samplesToGenerate = int(duration * samplingRate);
        for (int i = 0; i < samplesToGenerate; i++) {
            float currentTime = float(i) / samplingRate;
            float sampleValue = 0.0;
            sampleValue += sin(TWO_PI * frequency * currentTime);
            sampleValue += 0.8 * sin(TWO_PI * 3 * frequency * currentTime);
            sampleValue += 0.8 * sin(TWO_PI * 4 * frequency * currentTime);
            soundSamples.leftChannelSamples[i] = amplitude * sampleValue;
            soundSamples.rightChannelSamples[i] = soundSamples.leftChannelSamples[i];
        }
        
        soundSamples.postprocessEffect(2, 7, amplitude, 0);
    }

    // This function generates a repeating narrow pulse
    private void generateRepeatingNarrowPulse(float amplitude, float frequency, float duration) {
        int samplesToGenerate = int(duration * samplingRate);
        float oneCycle = samplingRate / frequency;
        float upSamples = min(oneCycle / 2, 5);
        for(int i = 0; i < samplesToGenerate && i < soundSamples.totalSamples; ++i) {
            float whereInCycle = i % int(oneCycle);
            if (whereInCycle < upSamples) {
                soundSamples.leftChannelSamples[i] = amplitude * maxValue;
                soundSamples.rightChannelSamples[i] = soundSamples.leftChannelSamples[i];
            } else {
                soundSamples.leftChannelSamples[i] = amplitude * minValue;
                soundSamples.rightChannelSamples[i] = soundSamples.leftChannelSamples[i];
            }
        }
    }

    // This function generates a triangle wave using the time domain method
    private void generateTriangleInTimeDomain(float amplitude, float frequency, float duration) {
        int samplesToGenerate = int(duration * samplingRate);
        int oneCycle = int(samplingRate / frequency);
        int halfCycle = oneCycle / 2;
        for (int i = 0; i < samplesToGenerate; i++) {
            int cyclePosition = i % oneCycle;
            float cycleProgress = float(cyclePosition) / oneCycle;
            float sampleValue = 0.0;
            if (cyclePosition < halfCycle) {
               sampleValue = ((maxValue - minValue) * (1 - (cycleProgress/0.5)) + minValue); 
            } else {
               sampleValue = ((maxValue - minValue) * ((cycleProgress - 0.5)/0.5) + minValue); 
            }
            soundSamples.leftChannelSamples[i] = amplitude * sampleValue;
            soundSamples.rightChannelSamples[i] = soundSamples.leftChannelSamples[i];
        }
    }

    // This function generates a science fiction movie sound using FM synthesis
    private void generateSciFiSound(float amplitude, float frequency, float duration) {
        int samplesToGenerate = int(duration * samplingRate);
        for (int i = 0; i < samplesToGenerate; i++) {
            float currentTime = float(i) / samplingRate;
            float sampleValue = amplitude * sin(TWO_PI * 500 * currentTime + 10.0 * sin(TWO_PI * 4910.3 * currentTime));
            soundSamples.leftChannelSamples[i] = sampleValue;
            soundSamples.rightChannelSamples[i] = soundSamples.leftChannelSamples[i];
        }
        
        soundSamples.postprocessEffect(2, 7, amplitude, 0);
    }

    // This function generate a sound using Karplus-Strong algorithm
    private void generateKarplusStrongSound2(float amplitude, float frequency, float duration) {
        // Fill array with 256Hz Sin wave
        generateSineInTimeDomain(amplitude, 512, duration);
        
        // Apply KS Algorithm
        float blendThreshold = 0.5;
        int samplesToGenerate = int(duration * samplingRate);
        int delaySamples = int(samplingRate / frequency);
        for (int i = delaySamples + 1; i < samplesToGenerate; i++) {
            float rand = random(0, 1);
            float sampleValue = 0.5 * (soundSamples.leftChannelSamples[i - delaySamples] + soundSamples.leftChannelSamples[i - delaySamples - 1]);
            if (rand > blendThreshold) {
                sampleValue *= -1;
            }
             
            soundSamples.leftChannelSamples[i] = sampleValue;
            soundSamples.rightChannelSamples[i] = soundSamples.leftChannelSamples[i];
        }
        
        soundSamples.postprocessEffect(2, 7, amplitude, 0);
    }

    // This function generates a waveform that is the multiplication of another 2 waveforms
    // Use AudioSamples::reMap if needed
    private void generateAxB(int soundA, int soundB, float amplitude, float frequency, float duration) {
        generateSound(soundA, amplitude, frequency, duration);
        soundSamples.reMap(minValue, maxValue, 0, 1);
        float[] samplesA = new float[soundSamples.leftChannelSamples.length];
        for (int i = 0; i < samplesA.length; i++) {
           samplesA[i] = soundSamples.leftChannelSamples[i];
        }
        
        generateSound(soundB, amplitude, frequency, duration);
        soundSamples.reMap(minValue, maxValue, 0, 1);
        for (int i = 0; i < samplesA.length; i++) {
           float sampleValue = samplesA[i] * soundSamples.leftChannelSamples[i];
           soundSamples.leftChannelSamples[i] = sampleValue;
           soundSamples.rightChannelSamples[i] = soundSamples.leftChannelSamples[i];
        }
        
        soundSamples.reMap(0, 1, minValue, maxValue);
    }

    // You can add your own sound if you want to
    private void generateSound20(float amplitude, float frequency, float duration) {
      generateWhiteNoise(amplitude, frequency, duration);
        
        // Apply KS Algorithm
        float blendThreshold = 0.8;
        int samplesToGenerate = int(duration * samplingRate);
        int delaySamples = int(samplingRate / frequency);
        for (int i = delaySamples + 1; i < samplesToGenerate; i++) {
            float rand = random(0, 1);
            float sampleValue = 0.5 * (soundSamples.leftChannelSamples[i - delaySamples] + soundSamples.leftChannelSamples[i - delaySamples - 1]);
            if (rand > blendThreshold) {
                sampleValue *= -1;
            }
             
            soundSamples.leftChannelSamples[i] = sampleValue;
            soundSamples.rightChannelSamples[i] = soundSamples.leftChannelSamples[i];
        }
        
        soundSamples.postprocessEffect(2, 7, amplitude, 0);
    }

    // You can add your own sound if you want to
    private void generateSound21(float amplitude, float frequency, float duration) {
        int samplesToGenerate = int(duration * samplingRate);
        for (int i = 0; i < samplesToGenerate; i++) {
            float currentTime = float(i) / samplingRate;
            float sampleValue = amplitude * sin(TWO_PI * 20 * currentTime + 0.75 * sin(TWO_PI * 20 * currentTime));
            soundSamples.leftChannelSamples[i] = sampleValue;
            soundSamples.rightChannelSamples[i] = soundSamples.leftChannelSamples[i];
        }
        
        soundSamples.postprocessEffect(2, 7, amplitude, 0);
    }

    // You can add your own sound if you want to
    private void generateSound22(float amplitude, float frequency, float duration) {
        int samplesToGenerate = int(duration * samplingRate);
        for (int i = 0; i < samplesToGenerate; i++) {
            float currentTime = float(i) / samplingRate;
            float sampleValue = sin(TWO_PI * 532 * currentTime) + 0.01 * sin(TWO_PI * 1224 * currentTime);
            soundSamples.leftChannelSamples[i] = sampleValue;
            soundSamples.rightChannelSamples[i] = soundSamples.leftChannelSamples[i];
        }
        
        soundSamples.postprocessEffect(2, 7, amplitude, 0);
    }

    // You can add your own sound if you want to
    private void generateSound23(float amplitude, float frequency, float duration) {
        generateSound(1, amplitude, frequency, duration);
        float[] samplesA = new float[soundSamples.leftChannelSamples.length];
        for (int i = 0; i < samplesA.length; i++) {
           samplesA[i] = soundSamples.leftChannelSamples[i];
        }
        
        generateSound(14, amplitude / 10, 4 * frequency, duration);
        for (int i = 0; i < samplesA.length; i++) {
           float sampleValue = samplesA[i] + soundSamples.leftChannelSamples[i];
           soundSamples.leftChannelSamples[i] = sampleValue;
           soundSamples.rightChannelSamples[i] = soundSamples.leftChannelSamples[i];
        }
        
        soundSamples.postprocessEffect(2, 7, amplitude, 0);
    }

    // You can add your own sound if you want to
    private void generateSound24(float amplitude, float frequency, float duration) {
        if (compareToMIDIPitch(38, frequency)) {           // Play Snare
            generateKarplusStrongSound2(amplitude, 129.5, duration);
            soundSamples.postprocessEffect(2, 4, Float.NaN, Float.NaN);
            soundSamples.postprocessEffect(2, 5, Float.NaN, Float.NaN);
            soundSamples.postprocessEffect(2, 9, .01, .1);
            soundSamples.postprocessEffect(2, 2, 3, Float.NaN);
        } else if (compareToMIDIPitch(36, frequency)) {    // Play Kick
            generateSound21(amplitude, 20, duration);
            soundSamples.postprocessEffect(2, 2, 1, Float.NaN);
        } else if (compareToMIDIPitch(49, frequency)) {    // Play Cymbal
            float extendedDuration = 48 * duration;
            if (showDebugMessages) {
               println(">>>  Cymbal duration is " + extendedDuration); 
            }
            soundSamples = new AudioSamples(extendedDuration, samplingRate);
            generateSound20(1.0, 20, duration);
            soundSamples.postprocessEffect(2, 11, Float.NaN, Float.NaN);
            soundSamples.postprocessEffect(2, 9, 0.2, 0.9);
            soundSamples.postprocessEffect(2, 5, Float.NaN, Float.NaN);
            soundSamples.postprocessEffect(2, 2, 2, Float.NaN);
        } else if (compareToMIDIPitch(42, frequency)) {    // Play HiHat
            generateKarplusStrongSound2(amplitude * 0.5, 418.5, duration);
            soundSamples.postprocessEffect(2, 11, Float.NaN, Float.NaN);
            soundSamples.postprocessEffect(2, 5, Float.NaN, Float.NaN);
            soundSamples.postprocessEffect(2, 5, Float.NaN, Float.NaN);
            soundSamples.postprocessEffect(2, 2, Float.NaN, Float.NaN);

        }
    }
    
    // This function convert MIDI pitch to frequency
    private boolean compareToMIDIPitch(int MIDIPitch, float frequency) {
      
        int baseMIDIPitch = 21;
        float baseFrequency = 27.5;
        
        int pitchDelta = MIDIPitch - baseMIDIPitch;
        float pitchFrequency = baseFrequency * pow(2, float(pitchDelta) / 12);

        return abs(frequency - pitchFrequency) < 1E-5;
    }
}