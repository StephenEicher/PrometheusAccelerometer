#include "SPI.h"
#include "Communication.h"
#include "adxl372.h"
//#include <SD.h>
#include "SdFat.h"
#include "sdios.h"
#define CS_PIN 10

struct adxl372_device adxl372;
unsigned char devId;
AccelTriplet_t accel_data;
const int SD_CHIP_SELECT = 4;
const int AC_CHIP_SELECT = 10;
SdFat sd;
// test file
SdFile file;
unsigned long startTime;
char fileName[13] = "Trial00.txt";
  
typedef struct {
  float x;
  float y;
  float z;
}acceleration_G_t;
acceleration_G_t data_G;
int temp = 0;

// Serial output stream
ArduinoOutStream cout(Serial);
//------------------------------------------------------------------------------
// store error strings in flash to save RAM
#define error(s) sd.errorHalt(F(s))
//------------------------------------------------------------------------------
void StartRecording() {
    cout << F("Data recording sequence intiated\n");
    cout << F("Checking for previous flights...\n");
    
    for (int i = 0; i <= 99; i++){
      char FileNum[3] = "00";  
      itoa(i, FileNum, 10);
      if (i < 10){
        fileName[6] = FileNum[0];
      } else if (i >= 10) {
        fileName[6] = FileNum[1];
        fileName[5] = FileNum[0];
      } 
    
      if (sd.exists(fileName)) {
        //trial already exists
        cout << F("Flight number: ") << i << F(" already exists\n");
      }
      else {  
        break;
      }  
    }
    
    cout << F("Creating file: ") << fileName << F("\n");
    cout << F("Press any key to stop...\n");
    
    file.open(fileName, O_CREAT | O_WRITE);
    bool closefile = false;
    uint32_t m = micros();
    bool alwaystrue = true;
    int streak = 0;
    int blinkcount = 0;
    while (alwaystrue){
      adxl372_Get_Accel_data(&adxl372, &accel_data);  
      /*Transform in G values*/
      data_G.x = (float)accel_data.x * 100 / 1000;
      data_G.y = (float)accel_data.y * 100 / 1000;
      data_G.z = (float)accel_data.z * 100 / 1000;
      file.printField((micros() - m), '\t');
      file.printField(data_G.x, '\t');
      file.printField(data_G.y, '\t');
      file.printField(data_G.z, '\n');
    
      //cout << F("x: ") << data_G.x << F("g\n");
      //cout << F("y: ") << data_G.y << F("g\n");
      //cout << F("z: ") << data_G.z << F("g\n");
      //m = micros() - m;
      //cout << F("PrintLatency: ") << m << F("usec\n");
      if (digitalRead(12) == 1){
    
      //cout << F("The current streak is: ") << streak << F("\n");
        streak++;
        if (streak > 1000){
          break;
        }
      }
      else{
        streak = 0;
      }
      if (blinkcount > 80){
//      digitalWrite(13, LOW);
//      delay(1000);
//      digitalWrite(13, HIGH);
        blinkcount = 0;  
      }
      blinkcount++;  
    }
    cout << F("Recording stopped\n");
    file.close();

  
}





//-------------------------------------------------------------------------------
void setup() {
  Serial.begin(9600);
//  while (!Serial){
//    ;
//  }
 
  
  //Disable the Accelerometer
  Serial.print("Disabling Accel device on pin: ");
  Serial.println(AC_CHIP_SELECT);
  pinMode(AC_CHIP_SELECT, OUTPUT);
  digitalWrite(AC_CHIP_SELECT, HIGH);
  Serial.print("Initializing SD card...");
 delay(100);
  
    if (!sd.begin(SD_CHIP_SELECT, SD_SCK_MHZ(50))) {
    sd.initErrorHalt();
  }
  Serial.println("initialization done.");

  // open the file. note that only one file can be open at a time,
  // so you have to close this one before opening another.


//      if (!file.open(fileName, O_CREAT | O_WRITE)) {
//      error("File Creation failed");
//    }

    
    //Disable the SD Pin
  Serial.print("Disabling SD device on pin: ");
  Serial.println(SD_CHIP_SELECT);
  pinMode(SD_CHIP_SELECT, OUTPUT);
  digitalWrite(SD_CHIP_SELECT, HIGH);
  pinMode(13, OUTPUT);
  digitalWrite(13, HIGH); // Set pin 13 to output some voltage -
  pinMode(9, OUTPUT);
  digitalWrite(9, HIGH); // Set pin 13 to output some voltage -
  //pinMode(12, OUTPUT);
  //digitalWrite(12, LOW);
  pinMode(12, INPUT);
  
  delay(1000);
  SPI.begin();
  SPI.setDataMode(SPI_MODE0); //CPHA = CPOL = 0    MODE = 0
  delay(1000);

  pinMode(CS_PIN, OUTPUT);
  pinMode(ADXL_INT1_PIN, INPUT);

  adxl372_Get_DevID(&adxl372, &devId);

  Serial.print("Device id: ");
  Serial.println(devId, HEX);

  adxl372_Set_Op_mode(&adxl372, FULL_BW_MEASUREMENT);
  adxl372_Set_ODR(&adxl372, ODR_6400Hz);
  delay(100);
  //Serial.print("Initializing SD card...");
  
 }

// ----------------------------------------------------
void loop() {
  
  bool SwitchStatus = digitalRead(12);
  if (SwitchStatus == 0) {
    temp++;
    if (temp > 2000){
      StartRecording();
      
    }
  } 
  else{
  temp = 0;
  }
cout << SwitchStatus << F("\n");

}
