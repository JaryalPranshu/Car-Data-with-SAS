proc import datafile = "H:\SAS files\car_insurance.csv"
 out = carins
 dbms = CSV;
run;

*1*;
proc freq; 
table gender vehicle_size vehicle_class; run;

*2*;

proc means; var Customer_Lifetime_Value; class gender; run;
proc means; var Customer_Lifetime_Value; class vehicle_size; run;
proc means; var Customer_Lifetime_Value; class vehicle_class; run;

*3*;

DATA work.cars3; 
  SET work.carins; 
  IF vehicle_size in ("Small") THEN delete;
RUN;

proc ttest data = work.cars3;
  class Vehicle_size;
  var Customer_Lifetime_Value;
run;
 
*4*;
proc ttest data = work.carins; var Customer_Lifetime_Value; class gender; run;

*5*;
proc anova data = work.carins;
class sales_channel;
model Customer_Lifetime_Value = sales_channel ;
means sales_channel ;
run;

proc means data = work.carins sum;
var Customer_Lifetime_Value; class sales_channel; run;

*6*;

proc glmmod data=work.carins outdesign=GLMDesign outparm=GLMParm NOPRINT;
   class Education Marital_Status;
   model Customer_Lifetime_Value = Education Marital_Status Income;run;

proc reg data=GLMDesign;
DummyVars: model Customer_Lifetime_Value = COL2-COL10;
ods select ParameterEstimates; RUN;

*7*;
proc freq data = work.carins;
tables renew_offer_type * response /chisq;
run;

*8*;
proc anova data = work.carins;
class renew_offer_type;
model Customer_Lifetime_Value = renew_offer_type ;
means renew_offer_type / lsd; run;

*9*; 
proc anova data =work.carins;
  class renew_offer_type state;
  model Customer_Lifetime_Value = renew_offer_type state renew_offer_type * state;
run;

*10a claim amount ~ vehicle size*;

proc anova data = work.carins;
class vehicle_size;
model Total_Claim_Amount = vehicle_size ;
means vehicle_size / lsd; run;

*10b gender ~ claim*;

proc ttest data = work.carins;
  class Gender;
  var Total_Claim_Amount;
run; 
proc means data = work.carins sum;
class gender;
var Total_Claim_Amount;
run;

*10c coverage ~ clt*;
proc anova data = work.carins;
class Coverage;
model Customer_Lifetime_Value = Coverage ;
means Coverage/ lsd; run;

