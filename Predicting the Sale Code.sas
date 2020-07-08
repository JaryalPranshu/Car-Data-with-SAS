data cars;
infile "H:\SAS files\Assignment 2\93cars.dat";
input Manufacturer $ 1-14 Model  $ 15-29 Type $ 30-36 Minimum_Price 38-40 Midrange_Price 43- 46 Maximum_Price 48-51 City_MPG 53-54 Highway_MPG 56-57 
Air_Bags_Standard 59 Drive_Train_Type 61 Num_of_Cylinders 63 Engine_size 65-67 Horse_Power 69-71 RPM 73-76 
#2 Engine_revolution_per_mile 1-4 Manual_Transmission_Available 6 Fuel_Tank_Capacity 8-11 Passenger_Capacity 13 Length 15-17
Wheelbase 19-21 Width 23-24 Uturn_space 26-27 Rear_Seat_Room 29-32 Luggage_Capacity 34-35 Weight 37-40 Domestic? 42;
run;

proc print; run;

*1a*; 
proc corr ;
var Horse_Power; with Midrange_Price;
run;

*Creating dummies* ; 
data s; set work.cars;
if Drive_Train_Type = "1" then drivetype_front = 1; else drivetype_front = 0;
if Drive_Train_Type = "2" then drivetype_all = 1; else drivetype_all = 0;
if Air_Bags_Standard="1" then ABS_Driver=1; else ABS_Driver=0;
if Air_Bags_Standard="2" then ABS_Driver_Passenger=1; else ABS_Driver_Passenger=0;
run;

*Dropping the fields after creating dummies*;
data cars93; set work.s(drop = Manufacturer Model Type Drive_Train_Type Air_Bags_Standard); run; 

*1b*;
proc reg data=work.cars93 plots = None;
model Midrange_Price = City_MPG ABS_Driver ABS_Driver_Passenger Horse_Power Manual_Transmission_Available Weight Domestic ;
run;

*1c5 * ;

proc reg data=work.cars93 plots = None;
model Midrange_Price = City_MPG ABS_Driver ABS_Driver_Passenger Horse_Power Manual_Transmission_Available Weight Domestic / stb ;
run;

*1c7*;

data hp; set work.cars93;
hp_sq = (Horse_Power)* (Horse_Power);
hp_lg = log(Horse_Power);
run;

proc reg data=work.hp plots = None;
model Midrange_Price = City_MPG ABS_Driver ABS_Driver_Passenger Horse_Power Manual_Transmission_Available Weight Domestic hp_sq ;
run;

proc reg data=work.hp plots = None;
model Midrange_Price = City_MPG ABS_Driver ABS_Driver_Passenger Horse_Power Manual_Transmission_Available Weight Domestic hp_lg ;
run;

*1c 8 *;

proc glm data=work.cars93 plots = None;
model Midrange_Price = City_MPG ABS_Driver ABS_Driver_Passenger Horse_Power Manual_Transmission_Available Domestic Weight Horse_Power*Weight ;
run;

* 1d*;
proc reg data=work.cars93 plots = None;
  model Midrange_Price =  drivetype_front drivetype_all ABS_Driver ABS_Driver_Passenger  City_MPG   
    Num_of_Cylinders  Horse_Power Manual_Transmission_Available Wheelbase  Width Weight Domestic;
run;

*2*;
data diamond;
infile "H:\SAS files\Assignment 2\diamond data.dat" firstobs = 2;
input Cut $ Color $ Clarity $ Carat Price ;
run;

*Fisher's Exact 2.1*;

proc freq data = work.diamond;
table Cut * Clarity / exact; run;  

*2.2*;
proc ttest data = work.diamond;
class Color;
var Price; run;

*2.3 creating dummies*;
data d;
Set diamond;
if Cut = "Ideal" then Cut_Ideal = 1 ; else Cut_Ideal= 0;
if Cut = "Good" then Cut_Good = 1; else Cut_Good = 0;
if Cut = "VeryGood" then Cut_Verygood = 1; else Cut_Verygood = 0;
if Color = "D" then Color_D = 1; else  Color_D = 0;
if Clarity = "VVS1" then  Clarity_VVS1 = 1; else Clarity_VVS1 = 0; 
if Clarity = "VVS2" then Clarity_VVS2 = 1; else Clarity_VVS2 = 0;
if Clarity = "VS1" then Clarity_VS1 = 1; else Clarity_VS1 = 0;
run;
data DIAM; set d(drop = Cut Color Clarity ); run; 

*Regression*;
proc reg data = diam plots = None;
model Price = Cut_Ideal Cut_Good Cut_Verygood Color_D Clarity_VVS1 Clarity_VVS2 Clarity_VS1 Carat;run;
