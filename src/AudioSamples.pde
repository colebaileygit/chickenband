class AudioSamples {

    public float duration;
    public int samplingRate;
    public int totalSamples;
    public float[] leftChannelSamples;
    public float[] rightChannelSamples;
    
    public float lastUsedAmplitude = 1.0;

    // Constructor
    AudioSamples(float duration, int samplingRate) {
        this.duration = duration;
        this.samplingRate = samplingRate;

        totalSamples = int(duration * samplingRate);
        leftChannelSamples = new float[totalSamples];
        rightChannelSamples = new float[totalSamples];

        clear();
    }

    public void add(AudioSamples other, float stereoPosition, float startPosition) {
        add(other, stereoPosition, startPosition, other.duration);
    }

    // Add anohter AudioSamples to this
    // The input parameters are:
    // - another AudioSamples that to be added to this AudioSamples
    // - the stereo position, in the range [0, 1]. 0 means left only, 0.5 is in the middle and 1 means right only.
    // - the start time, in seconds
    // - the duration, in seconds
    public void add(AudioSamples other, float stereoPosition, float startPosition, float duration) {
        // In this function we add the individual sound samples to the complete music sequence samples.
        // Another way to think about it is that we are adding a single musical note to the complete music sequence.

        int startSample = int(startPosition * samplingRate);
        int samplesToCopy = int(duration * samplingRate);

        if(startSample >= totalSamples) return;

        float leftVol = 1.0 - stereoPosition;
        float rightVol = stereoPosition;

        for(int i = startSample, j = 0; i < totalSamples && j < samplesToCopy; ++i, ++j) {
            leftChannelSamples[i] += leftVol * other.leftChannelSamples[j];
            rightChannelSamples[i] += rightVol * other.rightChannelSamples[j];
        }
    }

    // Clear all samples by setting them to 0
    public void clear() {
        for(int i = 0; i < totalSamples; ++i) {
            leftChannelSamples[i] = rightChannelSamples[i] = 0;
        }
    }

    // Transform the samples to a specified range of amplitude
    private void reMap(float sourceRangeMin, float sourceRangeMax, float destinationRangeMin, float destinationRangeMax) {
        float sourceRange = sourceRangeMax - sourceRangeMin;
        float destinationRange = destinationRangeMax - destinationRangeMin;
        float factor = destinationRange / sourceRange;
        for(int i = 0; i < totalSamples; ++i) {
            leftChannelSamples[i] = destinationRangeMin + (leftChannelSamples[i] - sourceRangeMin) * factor;
            rightChannelSamples[i] = destinationRangeMin + (rightChannelSamples[i] - sourceRangeMin) * factor;
        }
    }

    // The following 4 functions apply post processing to this AudioSamples
    void applyPostProcessing(int postprocess) {
        postprocessEffect(2, postprocess, float(""), float(""));
    }

    void applyPostProcessing(int channel, int postprocess) {
        postprocessEffect(channel, postprocess, float(""), float(""));
    }

    void applyPostProcessing(int channel, int postprocess, float param1) {
        postprocessEffect(channel, postprocess, param1, float(""));
    }

    void applyPostProcessing(int channel, int postprocess, float param1, float param2) {
        postprocessEffect(channel, postprocess, param1, param2);
    }

    // Apply post processing to this AudioSamples, on the specified channel(s)
    // target:
    // - 0 left channel only
    // - 1 right channel only
    // - 2 both channels
    void postprocessEffect(int target, int postprocess, float param1, float param2) {
        // Do nothing if the target is not valid
        if(target < 0 || target > 2) {
            return;
        }

        switch (postprocess) {
            case (1): break; // Nothing is done to the sound
            case (2): applyExponentialDecay(target, param1, param2); break; // Exponential decay
            case (3): applyLowPassFilter(target, param1, param2); break; // Low pass filter
            case (4): applyBandRejectFilter(target, param1, param2); break; // Band reject filter
            case (5): applyFadeIn(target, param1, param2); break; // Linear fade in
            case (6): applyReverse(target, param1, param2); break; // Reverse
            case (7): applyBoost(target, param1, param2); break; // Boost
            case (8): applyTremolo(target, param1, param2); break; // Tremolo
            case (9): applyEcho(target, param1, param2); break; // Echo
            case(10): applyFadeOut(target, param1, param2); break; // You can add your own post processing if you want to
            case(11): applyHighPassFilter(target, param1, param2);
        }
    }

    // Apply exponential decay
    private void applyExponentialDecay(int target, float param1, float param2) {

        // Set up the target(s)
        float[] input = new float[0];
        float[] input2 = new float[0];
        switch(target) {
            case(0): input = leftChannelSamples; break;
            case(1): input = rightChannelSamples; break;
            case(2): input = leftChannelSamples; input2 = rightChannelSamples; break;
        }

        float timeConstant = 0.2;  // decay constant, see PDF notes for explanation
        if(!Float.isNaN(param1)) {
            timeConstant = param1;
        }

        for(int i = 0; i < input.length; ++i) {
            float currentTime = float(i) / samplingRate;
            float decayMultiplier = (float) Math.exp(-1 * currentTime / timeConstant);
            input[i] = input[i] * decayMultiplier;

            // Handle the second channel if needed
            if(input2.length > 0) {
                input2[i] = input2[i] * decayMultiplier;
            }
        }
    }

    // Apply low pass filter
    private void applyLowPassFilter(int target, float param1, float param2) {

        // Set up the target(s)
        float[] input = new float[0];
        float[] input2 = new float[0];
        switch(target) {
            case(0): input = leftChannelSamples; break;
            case(1): input = rightChannelSamples; break;
            case(2): input = leftChannelSamples; input2 = rightChannelSamples; break;
        }

        float[] output = new float[input.length];
        float[] output2 = new float[input2.length];
        for (int i = 2; i < totalSamples; i++) {
           output[i] = 0.5 * input[i] + 0.5 * input[i - 1];
           if (input2.length > 0) {
              output2[i] = 0.5 * input2[i] + 0.5 * input2[i - 1];
           }
        }
        
        for (int i = 0; i < totalSamples; i++) {
           input[i] = output[i];
           if (input2.length > 0) {
              input2[i] = output2[i]; 
           }
        }
    }
    
    private void applyHighPassFilter(int target, float param1, float param2) {
        // Set up the target(s)
        float[] input = new float[0];
        float[] input2 = new float[0];
        switch(target) {
            case(0): input = leftChannelSamples; break;
            case(1): input = rightChannelSamples; break;
            case(2): input = leftChannelSamples; input2 = rightChannelSamples; break;
        }

        float[] output = new float[input.length];
        float[] output2 = new float[input2.length];
        for (int i = 2; i < totalSamples; i++) {
           output[i] = 0.5 * input[i] - 0.5 * input[i - 1];
           if (input2.length > 0) {
              output2[i] = 0.5 * input2[i] - 0.5 * input2[i - 1];
           }
        }
        
        for (int i = 0; i < totalSamples; i++) {
           input[i] = output[i];
           if (input2.length > 0) {
              input2[i] = output2[i]; 
           }
        }
    }

    // Apply band reject filter
    private void applyBandRejectFilter(int target, float param1, float param2) {

        // Set up the target(s)
        float[] input = new float[0];
        float[] input2 = new float[0];
        switch(target) {
            case(0): input = leftChannelSamples; break;
            case(1): input = rightChannelSamples; break;
            case(2): input = leftChannelSamples; input2 = rightChannelSamples; break;
        }

        float[] output = new float[input.length];
        float[] output2 = new float[input2.length];
        for (int i = 2; i < totalSamples; i++) {
           output[i] = 0.5 * input[i] + 0.5 * input[i - 2];
           if (input2.length > 0) {
              output2[i] = 0.5 * input2[i] + 0.5 * input2[i - 2];
           }
        }
        
        for (int i = 0; i < totalSamples; i++) {
           input[i] = output[i];
           if (input2.length > 0) {
              input2[i] = output2[i]; 
           }
        }
    }

    // Apply linear fade in
    private void applyFadeIn(int target, float param1, float param2) {

        // Set up the target(s)
        float[] input = new float[0];
        float[] input2 = new float[0];
        switch(target) {
            case(0): input = leftChannelSamples; break;
            case(1): input = rightChannelSamples; break;
            case(2): input = leftChannelSamples; input2 = rightChannelSamples; break;
        }

        float fadeValue = 0.1;  // fade in duration, in seconds
        if(!Float.isNaN(param1)) {
            fadeValue = param1;
        }

        int fadeSamples = int(totalSamples * fadeValue);
        if (fadeSamples > totalSamples) {
            fadeSamples = totalSamples; 
        }
        
        for (int i = 0; i < fadeSamples; i++) {
            float multiplier = float(i) / fadeSamples; 
            input[i] = input[i] * multiplier;
            if (input2.length > 0) {
               input2[i] = input2[i] * multiplier; 
            }
        }
    }
    
    // Apply linear fade in
    private void applyFadeOut(int target, float param1, float param2) {

        // Set up the target(s)
        float[] input = new float[0];
        float[] input2 = new float[0];
        switch(target) {
            case(0): input = leftChannelSamples; break;
            case(1): input = rightChannelSamples; break;
            case(2): input = leftChannelSamples; input2 = rightChannelSamples; break;
        }

        float fadeValue = 0.15;  // fade in duration, in seconds
        if(!Float.isNaN(param1)) {
            fadeValue = param1;
        }
        
        int totalRealSamples = totalSamples;
        for (int i = input.length - 1; i >= 0; i--) {
           if (input[i] == 0) {
              totalRealSamples--; 
           } else {
               break;
           }
        }

        int fadeSamples = int(samplingRate * fadeValue);
        if (fadeSamples > totalRealSamples) {
            fadeSamples = totalRealSamples; 
        }
        
        for (int i = totalRealSamples - fadeSamples; i < totalRealSamples; i++) {
            float multiplier = float(totalRealSamples - i) / fadeSamples; 
            input[i] = input[i] * multiplier;
            if (input2.length > 0) {
               input2[i] = input2[i] * multiplier; 
            }
        }
    }

    // Apply reverse
    private void applyReverse(int target, float param1, float param2) {

        // Set up the target(s)
        float[] input = new float[0];
        float[] input2 = new float[0];
        switch(target) {
            case(0): input = leftChannelSamples; break;
            case(1): input = rightChannelSamples; break;
            case(2): input = leftChannelSamples; input2 = rightChannelSamples; break;
        }

        for (int i = 0; i < (totalSamples - 1) / 2; i++) {
            swapValues(input, i, totalSamples - 1 - i);
            if (input2.length > 0) {
               swapValues(input2, i, totalSamples - 1 - i); 
            }
        }
    }
    
    private void swapValues(float[] array, int index1, int index2) {
       float tmp = array[index1];
       array[index1] = array[index2];
       array[index2] = tmp;
    }

    // Apply boost
    private void applyBoost(int target, float amplitude, float param2) {

        // Set up the target(s)
        float[] input = new float[0];
        float[] input2 = new float[0];
        switch(target) {
            case(0): input = leftChannelSamples; break;
            case(1): input = rightChannelSamples; break;
            case(2): input = leftChannelSamples; input2 = rightChannelSamples; break;
        }
       
        
        if (Float.isNaN(amplitude)) {
            amplitude = lastUsedAmplitude;
        } else {
           lastUsedAmplitude = amplitude; 
        }

        // Find largest value
        float largestValue = 0.0;
        for (int i = 0; i < totalSamples; i++) {
            float localLargestValue = input[i];  
            if(input2.length > 0) {
                localLargestValue = max(abs(input[i]), abs(input2[i]));
            }
            if (localLargestValue > largestValue) largestValue = localLargestValue;
        }
        
        if (largestValue == 0.0) return;
        
        float min = -1.0;
        float max = 1.0;
        
        // Divide all samples by largest value
        float limit = max((-1 * min), max);
        float multiplier = amplitude * limit / largestValue;
        multiplier *= amplitude;
        for (int i = 0; i < totalSamples; i++) {
            input[i] = multiplier * input[i];
            if (input2.length > 0) {
                input2[i] = multiplier * input2[i];
            }
        }
    }

    // Apply tremolo
    private void applyTremolo(int target, float param1, float param2) {

        // Set up the target(s)
        float[] input = new float[0];
        float[] input2 = new float[0];
        switch(target) {
            case(0): input = leftChannelSamples; break;
            case(1): input = rightChannelSamples; break;
            case(2): input = leftChannelSamples; input2 = rightChannelSamples; break;
        }

        float tremoloFrequency = 10; // Frequency of the tremolo effect, change as appropriate
        if(!Float.isNaN(param1)) {
            tremoloFrequency = param1;
        }
        float wetness = 0.0;
        if(!Float.isNaN(param2)) {
            wetness = param2;
        }

        for (int i = 0; i < totalSamples; i++) {
            float currentTime = float(i) / samplingRate;
            float multiplier = (1.0 - wetness) / 2 * sin(TWO_PI * tremoloFrequency * currentTime) + (1.0 + wetness) / 2;
            input[i] = multiplier * input[i];
            if (input2.length > 0) {
               input2[i] = multiplier * input2[i]; 
            }
        }
    }

    // Apply echo
    private void applyEcho(int target, float param1, float param2) {
        // You can find pseudo-code for this in the PDF file.
        // You only need to handle one delay line for this project.

        // Set up the target(s)
        float[] input = new float[0];
        float[] input2 = new float[0];
        switch(target) {
            case(0): input = leftChannelSamples; break;
            case(1): input = rightChannelSamples; break;
            case(2): input = leftChannelSamples; input2 = rightChannelSamples; break;
        }

        float delayLineDuration = 0.05; // Length of delay line, in seconds

        if(!Float.isNaN(param1)) {
            delayLineDuration = param1;
        }

        // Need to declare the multiplier for the delay line(s) (just one delay line in this example code)
        float delayLineMultiplier = 0.1;

        if(!Float.isNaN(param2)) {
            delayLineMultiplier = param2;
        }

        int delayLineLength = (int)Math.floor(delayLineDuration * samplingRate);
        float[] delayLineSamples = new float[delayLineLength];
        for (int i = 0; i < delayLineLength; i++) {
           delayLineSamples[i] = 0.0f; 
        }
        
        boolean clipping = false;
        float delayLineOutput;
        for (int i = 0; i < totalSamples - 1; i++) {
           if (i >= delayLineLength) {
              delayLineOutput = delayLineSamples[i % delayLineLength]; 
           } else {
              delayLineOutput = 0;
           }
           
           input[i] += delayLineOutput * delayLineMultiplier;
           if (abs(input[i]) > 1.0) clipping = true; 
           if (input2.length > 0) {
              input2[i] += delayLineOutput * delayLineMultiplier; 
              if (abs(input2[i]) > 1.0) clipping = true;
           }
           
           delayLineSamples[i % delayLineLength] = input[i];  
        }
        
        if (clipping) {
          applyBoost(target, Float.NaN, Float.NaN);
        }
    }
}