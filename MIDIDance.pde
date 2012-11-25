import themidibus.*;


////////////////////////////////////////////////////////////////////////////////////////////////// init /////////////

// MIDI:
MidiBus myBus;
Tone[] activeTones = new Tone[0];

// For collecting a history of hits and adapting thresholds:
boolean LEARNING_MODE_ENABLED = true;
Hit[] collectedHits = new Hit[0];
String RECORDED_HITS_OUTPUT_FILE = "test1.txt";

int MIDI_CHANNEL = 0;
// String MIDI_DEVICE_NAME = "IAC-Bus 1"; // or "Java Sound Synthesizer" or "Native Instruments Kore Player Virtual Input"
String MIDI_DEVICE_NAME = "Java Sound Synthesizer";
int[] MIDI_PITCH_CODES = {41,53,55,41+1,53+1,55+1};
boolean[] MIDI_SIGNAL_IS_AN_INSTRUMENT = {true,true,true,true,true,true};
float TONE_LENGTH = 300.; // in ms

// The serial port:
boolean SIMULATE_SERIAL_INPUT = false;
int SERIAL_PORT_NUMBER = 0;
int SERIAL_PORT_BAUD_RATE = 9600;
Signal input;

int BLENDDOWN_ALPHA = 20;
int ROLLING_INCREMENT = 1;
int NUMBER_OF_SIGNALS = 6;
boolean DO_SIGNAL_REWIRING = false;
int[] SIGNAL_REWIRING = {3,4,5,0,1,2}; // swap controllers!
int i,j;
color[] LINE_COLORS = {#1BA5E0,#B91BE0,#E0561B,#42E01B,#EDE13B,#D4AADC};
float INIT_SECONDS = 12.;
float max_velocity;

Display screen;
String[] AXIS_LABELS = {"1x", "1y", "1z", "2x", "2y", "2z"};

void setup() { //////////////////////////////////////////////////////////////////////////////// setup /////////////
  size(600,400);
  screen = new Display(0);

  // Init serial ports
  input = new Signal(this,SIMULATE_SERIAL_INPUT);
    
  // List all available Midi devices on STDOUT. This will show each device's index and name.
  MidiBus.list();
  myBus = new MidiBus(this, -1, MIDI_DEVICE_NAME);
  delay(500);
  // println("DEBUG: playing test sound!");
  // new Tone(MIDI_CHANNEL, 64, 127, TONE_LENGTH, 0);
      
  // println("DEBUG: testing number extraction:"); 
  // String testString = "335,368,305\n-329,367,303\n326,366,305\n-345,0,-303\n330,371,303\n334,366,";
  // println("test string #"+j+":");
  // inBuffer = testStrings[j];
  // while (input.get_next_data_point()) {
  //   print("-> ");
  //   for(i=0; i<NUMBER_OF_SIGNALS; i++)
  //     print(values[i]+" ");
  //   print("\n");
  // }
  // exit();
}

void draw() { //////////////////////////////////////////////////////////////////////////////// draw /////////////
  fadeOutTones();
  screen.update_value_display();
  
  // read values from Arduino
  while (input.get_next_data_point()) {
    if(currently_in_init_phase()) {
      screen.alert("get ready!");
    } else { // during active phase
      input.send_controller_changes();
      input.detect_hit_and_play_tones();
    }
    screen.update_graphs();
  }
  delay(40);
  screen.simple_blenddown(BLENDDOWN_ALPHA);
}

void keyPressed() {
  if(key>=int('0') && key <=int('9')) {
    int ch = int(key) - int('0');
    if(ch < NUMBER_OF_SIGNALS) {
      if(LEARNING_MODE_ENABLED) {
        if(collectedHits.length > 0) {
          collectedHits[collectedHits.length-1].target_channel = ch;
          screen.alert("LEARN: Set target of last hit to #"+ch+" (accuracy now "+round(100.0*accuracy_of_past_hits())+"%)");
        }
      } else { // no learning mode
        screen.alert("Playing test tone of channel #"+ch);
        input.axis_dim[ch].play_your_tone(127,ch);
      }
    }
  } else {
  	switch(key) {
  	  case '+':
  		  input.xthresh += 0.02;
  		  screen.alert("xthresh = "+input.xthresh);
  		  break;
  		case '-':
  		  input.xthresh -= 0.02;
  		  screen.alert("xthresh = "+input.xthresh);
  		  break;
  		case 'd':
  		  println("--- DEBUG INFO ---");
  		  println("inBuffer = "+input.inBuffer);
  		  println("number of lines read = "+input.lines_read);
  		  println("rolling = "+screen.rolling);
        break;
      case 'r':
        input.clear_buffer();
        println("Reset input buffer.");
        break;
      case 'w':
        screen.alert("Writing recorded hits to file now.");
        String[] for_saving = new String[collectedHits.length];
        for(int n=0; n<collectedHits.length; n++) {
          for_saving[n] = collectedHits[n].status_information();
        }
        saveStrings(RECORDED_HITS_OUTPUT_FILE,for_saving);
        break;
      case 'h':
        String help_message = "help:\n"+
          "+ raise threshold\n"+
          "- lower threshold\n"+
          "h print this help message\n"+
          "r reset input buffer\n"+
          "w write recorded hits to disk\n"+
          "d print debug info\n"+
          "ESC quit\n";
        if(LEARNING_MODE_ENABLED) {
          help_message += "(0-9) assign target channel to last hit";
        } else {
          help_message += "(0-9) play test tone of channel";
        }        
        screen.alert(help_message);
        break;
  	}
	}
}

boolean currently_in_init_phase() {
  return (millis()/1000.0 < INIT_SECONDS);
}
