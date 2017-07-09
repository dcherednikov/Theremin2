//
//  Synthesizer.m
//  Theremin2
//
//  Created by Admin on 02/07/2017.
//  Copyright © 2017 MacBookPro. All rights reserved.
//

#import "Synthesizer.h"
#import <AudioToolbox/AudioToolbox.h>
#import "Oscillator.h"

#define CHECK(osStatus)     if ((osStatus) != noErr) { return (osStatus); };

static const NSInteger sampleRate = 44100;

static OSStatus renderTone(void *inRefCon,
                           AudioUnitRenderActionFlags *ioActionFlags,
                           const AudioTimeStamp *inTimeStamp,
                           UInt32 inBusNumber,
                           UInt32 inNumberFrames,
                           AudioBufferList *ioData) {
    
    Synthesizer *synthesizer = (__bridge Synthesizer *)inRefCon;
    Oscillator *firstOscillator = synthesizer.firstOscillator;
    Oscillator *secondOscillator = synthesizer.secondOscillator;
    Float32 *buffer = (Float32 *)ioData->mBuffers[0].mData;
    for (UInt32 frame = 0; frame < inNumberFrames; frame++) {
        
        buffer[frame] = firstOscillator.currentValue + secondOscillator.currentValue;
        
        [firstOscillator incrementPhaseForSampleRate:sampleRate
                                        andPitchInHz:synthesizer.pitch];
        [secondOscillator incrementPhaseForSampleRate:sampleRate
                                         andPitchInHz:synthesizer.pitch];
        [secondOscillator shiftPhase:synthesizer.phaseShift];
    }
    
    return noErr;
}

@interface Synthesizer ()

@property (nonatomic, assign) AudioUnit toneUnit;
@property (nonatomic, assign) AudioUnit mixerUnit;
@property (nonatomic, assign) AudioUnit outputUnit;
@property (nonatomic, assign) AudioUnit reverbUnit;
@property (nonatomic, assign) AUGraph graph;

@end


@implementation Synthesizer 

- (void)setReverb:(double)reverb {
    
    _reverb = reverb;
    [self setupReverb];
}

- (void)setCurrentPatch:(Patch *)patch {
    
    _firstOscillator.waveForm = patch.firstOscillatorWaveForm;
    _firstOscillator.amplitude = patch.firstOscillatorVolume;
    
    _secondOscillator.waveForm = patch.secondOscillatorWaveForm;
    _secondOscillator.amplitude = patch.secondOscillatorVolume;
    _secondOscillator.registerType = patch.secondOscillatorRegisterType;
    
    _phaseShift = patch.phaseShift;
    _reverb = patch.reverb;
}

- (Patch *)currentPatch {

    Patch *patch = [[Patch alloc] init];
    
    patch.firstOscillatorWaveForm = _firstOscillator.waveForm;
    patch.firstOscillatorVolume = _firstOscillator.amplitude;
    
    patch.secondOscillatorWaveForm = _secondOscillator.waveForm;
    patch.secondOscillatorVolume = _secondOscillator.amplitude;
    patch.secondOscillatorRegisterType = _secondOscillator.registerType;
    
    patch.phaseShift = _phaseShift;
    patch.reverb = _reverb;
    
    return patch;
}

- (instancetype)init {
    
    self = [super init];
    if (self) {
        
        _firstOscillator = [[Oscillator alloc] init];
        _secondOscillator = [[Oscillator alloc] init];
        OSStatus osStatus = [self setupToneGenerator];
        if (osStatus != noErr) {
            
            NSLog(@"tone generator initialization failed");
        }
    }
    
    return self;
}

- (OSStatus)setupToneGenerator {
    
    AUNode outputNode;
    AUNode mixerNode;
    AUNode reverbNode;
    
    AudioStreamBasicDescription streamFormat = [self streamFormat];
    AudioComponentDescription outputDescription = [self outputDescription];
    AudioComponentDescription mixerDescription = [self mixerDescription];
    AudioComponentDescription reverbDescription = [self reverbDescription];
    
    OSStatus osStatus = noErr;
    
    osStatus = NewAUGraph(&_graph); CHECK(osStatus)
    
    osStatus = AUGraphAddNode(_graph, &outputDescription, &outputNode); CHECK(osStatus)
    osStatus = AUGraphAddNode(_graph, &mixerDescription, &mixerNode ); CHECK(osStatus)
    osStatus = AUGraphAddNode(_graph, &reverbDescription, &reverbNode ); CHECK(osStatus)
    
    osStatus = AUGraphConnectNodeInput(_graph, mixerNode, 0, outputNode, 0); CHECK(osStatus)
    osStatus = AUGraphConnectNodeInput(_graph, reverbNode, 0, mixerNode, 0); CHECK(osStatus)
    
    osStatus = AUGraphOpen(_graph); CHECK(osStatus)
    osStatus = AUGraphNodeInfo(_graph, mixerNode, NULL, &_mixerUnit); CHECK(osStatus)
    osStatus = AUGraphNodeInfo(_graph, outputNode, NULL, &_outputUnit); CHECK(osStatus)
    osStatus = AUGraphNodeInfo(_graph, reverbNode, NULL, &_reverbUnit); CHECK(osStatus)
    
    osStatus = [self setBusCount]; CHECK(osStatus)
    osStatus = [self setNodeInputCallback:reverbNode]; CHECK(osStatus)
    osStatus = [self setInputStreamFormat:streamFormat]; CHECK(osStatus)
    osStatus = [self setOutputStreamFormat:streamFormat]; CHECK(osStatus)
    
    osStatus = AUGraphInitialize(_graph); CHECK(osStatus)
    
    osStatus = [self setupMixer]; CHECK(osStatus)
    osStatus = [self setupReverb]; CHECK(osStatus)
    
    osStatus = AUGraphInitialize(_graph); CHECK(osStatus)
    osStatus = AUGraphStart(_graph); CHECK(osStatus)
    
    return osStatus;
}

- (AudioStreamBasicDescription)streamFormat {
    
    const int bytesPerFloat = 4;
    const int bitsPerByte = 8;
    
    AudioStreamBasicDescription streamFormat;
    streamFormat.mSampleRate = sampleRate;
    streamFormat.mFormatID = kAudioFormatLinearPCM;
    streamFormat.mFormatFlags =
    kAudioFormatFlagsNativeFloatPacked | kAudioFormatFlagIsNonInterleaved;
    streamFormat.mBytesPerPacket = bytesPerFloat;
    streamFormat.mFramesPerPacket = 1;
    streamFormat.mBytesPerFrame = bytesPerFloat;
    streamFormat.mChannelsPerFrame = 1;
    streamFormat.mBitsPerChannel = bytesPerFloat * bitsPerByte;
    
    return streamFormat;
}

- (AudioComponentDescription)outputDescription {
    
    AudioComponentDescription outputDescription;
    outputDescription.componentType = kAudioUnitType_Output;
    outputDescription.componentSubType = kAudioUnitSubType_RemoteIO;
    outputDescription.componentManufacturer = kAudioUnitManufacturer_Apple;
    
    return outputDescription;
}

- (AudioComponentDescription)mixerDescription {
    
    AudioComponentDescription mixerDescription;
    mixerDescription.componentType = kAudioUnitType_Mixer;
    mixerDescription.componentSubType = kAudioUnitSubType_MultiChannelMixer;
    mixerDescription.componentManufacturer = kAudioUnitManufacturer_Apple;
    
    return mixerDescription;
}

- (AudioComponentDescription)reverbDescription {
    
    AudioComponentDescription reverbDescription;
    reverbDescription.componentType = kAudioUnitType_Effect;
    reverbDescription.componentSubType = kAudioUnitSubType_Reverb2;
    reverbDescription.componentManufacturer = kAudioUnitManufacturer_Apple;
    
    return reverbDescription;
}

- (OSStatus)setBusCount {
    
    UInt32 numbuses = 1;
    OSStatus osStatus = AudioUnitSetProperty(_mixerUnit,
                                             kAudioUnitProperty_ElementCount,
                                             kAudioUnitScope_Input,
                                             0,
                                             &numbuses,
                                             sizeof(numbuses));
    
    return osStatus;
}

- (OSStatus)setNodeInputCallback:(AUNode)node {
    
    AURenderCallbackStruct callbackStruct;
    callbackStruct.inputProc = renderTone;
    callbackStruct.inputProcRefCon = (__bridge void *)(self);
    OSStatus osStatus = noErr;
    osStatus = AUGraphSetNodeInputCallback(_graph,
                                           node,
                                           0,
                                           &callbackStruct);
    
    return osStatus;
}

- (OSStatus)setInputStreamFormat:(AudioStreamBasicDescription)streamFormat {
    
    OSStatus osStatus = noErr;
    osStatus = AudioUnitSetProperty(_mixerUnit,
                                    kAudioUnitProperty_StreamFormat,
                                    kAudioUnitScope_Input,
                                    0,
                                    &streamFormat,
                                    sizeof(AudioStreamBasicDescription)); CHECK(osStatus)
    osStatus = AudioUnitSetProperty(_reverbUnit,
                                    kAudioUnitProperty_StreamFormat,
                                    kAudioUnitScope_Input,
                                    0,
                                    &streamFormat,
                                    sizeof(AudioStreamBasicDescription)); CHECK(osStatus)
    
    return osStatus;
}

- (OSStatus)setOutputStreamFormat:(AudioStreamBasicDescription)streamFormat {

    OSStatus osStatus = noErr;
    osStatus = AudioUnitSetProperty(_mixerUnit,
                                    kAudioUnitProperty_StreamFormat,
                                    kAudioUnitScope_Output,
                                    0,
                                    &streamFormat,
                                    sizeof(AudioStreamBasicDescription)); CHECK(osStatus)
    osStatus = AudioUnitSetProperty(_reverbUnit,
                                    kAudioUnitProperty_StreamFormat,
                                    kAudioUnitScope_Output,
                                    0,
                                    &streamFormat,
                                    sizeof(AudioStreamBasicDescription)); CHECK(osStatus)
    osStatus = AudioUnitSetProperty(_outputUnit,
                                    kAudioUnitProperty_StreamFormat,
                                    kAudioUnitScope_Output,
                                    1,
                                    &streamFormat,
                                    sizeof(AudioStreamBasicDescription));
    
    return osStatus;
}

- (OSStatus)setupMixer {
    
    OSStatus osStatus = noErr;
    osStatus = AudioUnitSetParameter(_mixerUnit,
                                     kMultiChannelMixerParam_Enable,
                                     kAudioUnitScope_Input,
                                     0,
                                     YES,
                                     0); CHECK(osStatus)
    osStatus = AudioUnitSetParameter(_mixerUnit,
                                     kMultiChannelMixerParam_Volume,
                                     kAudioUnitScope_Input,
                                     0,
                                     1,
                                     0); CHECK(osStatus)
    osStatus = AudioUnitSetParameter(_mixerUnit,
                                     kMultiChannelMixerParam_Volume,
                                     kAudioUnitScope_Output,
                                     0,
                                     0,
                                     0);
    
    return osStatus;
}

- (OSStatus)setupReverb {
    
    OSStatus osStatus;
    osStatus = AudioUnitSetParameter(_reverbUnit,
                                     kAudioUnitScope_Global,
                                     0,
                                     kReverb2Param_DryWetMix,
                                     _reverb,
                                     0);
    
    return osStatus;
}


#pragma mark - public methods

- (void)playPitchInHz:(double)pitch atVolume:(double)volume {
    
    _pitch = pitch;
    AudioUnitSetParameter(_mixerUnit,
                          kMultiChannelMixerParam_Volume,
                          kAudioUnitScope_Output,
                          0,
                          volume,
                          0);
}

- (void)stop {
    
    AudioUnitSetParameter(_mixerUnit,
                          kMultiChannelMixerParam_Volume,
                          kAudioUnitScope_Output,
                          0,
                          0,
                          0);
}

@end
