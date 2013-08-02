String RECORDED_HITS_OUTPUT_FILE = "test-17-2036.txt";
String RECORDED_HITS_INPUT_FILE = RECORDED_HITS_OUTPUT_FILE;

final int MIDI_CHANNEL = 0;
// String MIDI_DEVICE_NAME = "IAC-Bus 1";
//String MIDI_DEVICE_NAME = "Java Sound Synthesizer";
// String MIDI_DEVICE_NAME = "Native Instruments Kore Player Virtual Input";
String MIDI_DEVICE_NAME = "LoopBe Internal MIDI";
final int NUMBER_OF_SIGNALS = 3+3;
final int NUMBER_OF_BUTTONS = 2+2;
final boolean SIMULATE_SERIAL_INPUT = false;
final int NUMBER_OF_LINES_TO_SKIP_ON_INIT = 10;
final int SERIAL_PORT_NUMBER = 0;
final int SERIAL_PORT_BAUD_RATE = 6*9600;
// int[] SIGNAL_GROUP_OF_AXIS = {0, 0, 0, 1, 1, 1};
// int[] SIGNAL_GROUP_OF_AXIS = {0, 0, 0, 0, 0, 0};
int[] SIGNAL_GROUP_OF_AXIS = {0, 0, 0, 1, 1, 1};
int LENGTH_OF_PAST_VALUES = 30;
int TRIGGER_TYPE = MovementTriggerTypes.SingleThreshold;

final boolean[] MIDI_SIGNAL_IS_AN_INSTRUMENT = {true,true,true,true,true,true}; // 1 for each outcome
final float TONE_LENGTH = 300.; // in ms

final String[] AXIS_LABELS = {"1x", "1y", "1z", "2x", "2y", "2z"};

boolean BAYESIAN_MODE_ENABLED = true;
String[] OUTCOMES_LABEL = { "R null", "L null", "R side hit ", "L reach pop", "R clock", "L up point", "L tut down", "L writst rotate", "R wrist rotate" };

int[] MIDI_PITCH_CODES =  { -1, -1, 41, 43, 46, 52, 48, 51, 40 };
//int[] MIDI_PITCH_CODES =  { -1, -1, 69, 69, 69, 52, 48, 51, 40 };
int[] MIDI_BUTTON_CODES =  {72, 73, 74, 75};
int[] SIGNAL_GROUP_OF_OUTCOME = {0, 1, 0, 1, 0, 1, 1, 1, 0};
boolean[] SKIP_OUTCOME_WHEN_EVALUATING_BAYESIAN_DETECTOR = {true, true, false, false, false, false, false, false, false};

int[] NULL_OUTCOME_FOR_SIGNAL_GROUP = {0, 1};
int MAX_NUMBER_OF_EVENTS_FOR_LEARNING = 100;
// Note: Make sure the following outcomes are from all possible signal groups
int[] OUTCOME_TO_PLAY_DURING_REC_WHEN_GROUP_IS_TRIGGERED = {0, 3};

color[] LINE_COLORS = {#1BA5E0,#B91BE0,#E0561B,#42E01B,#EDE13B,#D4AADC};
float INIT_SECONDS = 10.0;

final int BLENDDOWN_ALPHA = 20;
final int ROLLING_INCREMENT = 1;
