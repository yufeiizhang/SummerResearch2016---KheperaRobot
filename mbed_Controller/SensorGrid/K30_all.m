%% define the serial port of each controller
mbed1 = serial('COM12','BaudRate',9600);
mbed2 = serial('COM13','BaudRate',9600);
mbed3 = serial('COM14','BaudRate',9600);
mbed4 = serial('COM16','BaudRate',9600);
mbed5 = serial('COM17','BaudRate',9600);
mbed6 = serial('COM18','BaudRate',9600);
mbed7 = serial('COM19','BaudRate',9600);
mbed8 = serial('COM21','BaudRate',9600);
%% oepn every serial port
fopen(mbed1);
fopen(mbed2);
fopen(mbed3);
fopen(mbed4);
fopen(mbed5);
fopen(mbed6);
fopen(mbed7);
fopen(mbed8);
counter = 0;

%% total number to count
XPOINTS = 2500;

%% start to read data
while(counter~=XPOINTS)
    
    %% Group 1
    %get data from controller
    a1 = fgetl(mbed1);
    values_1 = sscanf(a1,'%d');
    %get the rows and columns of each data
    [n,p] = size(values_1);
    %values_old_x is the last values for each controller
    %values_x is the current values for controller x
    %values_new_x is a matrix holding all values for controller x(not include bg_values)
    %bg_values_x is a matrix holding background values for controller x
    
    %1.if counter=0, let old value = current value, and total value =  current value
    %2.if n not equals to 3(means the dimension of data incorrect, let it
    %equal to last values.
    %3.if the difference between the current values and old values are
    %larger than 2000, use old values.
    %4.the first 500 points are background points. once counter equals
    %500,let the values_new_x to be bg_values and reset the length of values_new_x
    if (counter==0)
        values_old_1 = values_1;
        values_new_1 = values_1;
    elseif(n~=3)
        if(counter==500)
            values_new_1 = values_old_1;
        else
            values_new_1 = [values_new_1, values_old_1];
        end
    else
        if((values_1(1)-values_old_1(1))>2000 || (values_old_1(1)-values_1(1))>2000)
            values_1(1) = values_old_1(1);
        else
            values_old_1(1) = values_1(1);
        end
        if((values_1(2)-values_old_1(2))>2000 || (values_old_1(2)-values_1(2))>2000)
            values_1(2) = values_old_1(2);
        else
            values_old_1(2) = values_1(2);
        end
        if((values_1(3)-values_old_1(3))>2000 || (values_old_1(3)-values_1(3))>2000)
            values_1(3) = values_old_1(3);
        else
            values_old_1(3) = values_1(3);
        end
        if (counter==500)
            values_new_1 = values_1;
        else
            values_new_1 = [values_new_1,values_1];
        end
    end
        
    %% Group 2
    a2 = fgetl(mbed2);
    values_2 = sscanf(a2,'%d');
    [n,p] = size(values_2);
    if (counter==0)
        values_old_2 = values_2;
        values_new_2 = values_2;
    elseif(n~=3)
        if(counter==500)
            values_new_2 = values_old_2;
        else
            values_new_2 = [values_new_2, values_old_2];
        end
    else
        if((values_2(1)-values_old_2(1))>2000 || (values_old_2(1)-values_2(1))>2000)
            values_2(1) = values_old_2(1);
        else
            values_old_2(1) = values_2(1);
        end
        if((values_2(2)-values_old_2(2))>2000 || (values_old_2(2)-values_2(2))>2000)
            values_2(2) = values_old_2(2);
        else
            values_old_2(2) = values_2(2);
        end
        if((values_2(3)-values_old_2(3))>2000 || (values_old_2(3)-values_2(3))>2000)
            values_2(3) = values_old_2(3);
        else
            values_old_2(3) = values_2(3);
        end
        if(counter==500)
            values_new_2 = values_2;
        else
            values_new_2 = [values_new_2,values_2];
        end
    end
            
    %% Group 3
    a3 = fgetl(mbed3);
    values_3 = sscanf(a3,'%d');
    [n,p] = size(values_3);
    if (counter==0)
        values_old_3 = values_3;
        values_new_3 = values_3;
    elseif(n~=3)
        if (counter==500)
            values_new_3 = values_old_3;
        else
            values_new_3 = [values_new_3, values_old_3];
        end
    else
        if((values_3(1)-values_old_3(1))>2000 || (values_old_3(1)-values_3(1))>2000)
            values_3(1) = values_old_3(1);
        else
            values_old_3(1) = values_3(1);
        end
        if((values_3(2)-values_old_3(2))>2000 || (values_old_3(2)-values_3(2))>2000)
            values_3(2) = values_old_3(2);
        else
            values_old_3(2) = values_3(2);
        end
        if((values_3(3)-values_old_3(3))>2000 || (values_old_3(3)-values_3(3))>2000)
            values_3(3) = values_old_3(3);
        else
            values_old_3(3) = values_3(3);
        end
        if(counter==500)
            values_new_3 = values_3;
        else
            values_new_3 = [values_new_3,values_3];
        end
    end
    
    %% Group 4
    a4 = fgetl(mbed4);
    values_4 = sscanf(a4,'%d');
    [n,p] = size(values_4);
    if (counter==0)
        values_old_4 = values_4;
        values_new_4 = values_4;
    elseif(n~=3)
        if(counter==500)
            values_new_4 = values_old_4;
        else
            values_new_4 = [values_new_4, values_old_4];
        end
    else
        if((values_4(1)-values_old_4(1))>2000 || (values_old_4(1)-values_4(1))>2000)
            values_4(1) = values_old_4(1);
        else
            values_old_4(1) = values_4(1);
        end
        if((values_4(2)-values_old_4(2))>2000 || (values_old_4(2)-values_4(2))>2000)
            values_4(2) = values_old_4(2);
        else
            values_old_4(2) = values_4(2);
        end
        if((values_4(3)-values_old_4(3))>2000 || (values_old_4(3)-values_4(3))>2000)
            values_4(3) = values_old_4(3);
        else
            values_old_4(3) = values_4(3);
        end
        if(counter==500)
            values_new_4 = values_4;
        else
            values_new_4 = [values_new_4,values_4];
        end
    end
        
    
    %% Group 5
    a5 = fgetl(mbed5);
    values_5 = sscanf(a5,'%d');
    [n,p] = size(values_5);
    if (counter==0)
        values_old_5 = values_5;
        values_new_5 = values_5;
    elseif(n~=3)
        if(counter==500)
            values_new_5 = values_old_5;
        else
            values_new_5 = [values_new_5, values_old_5];
        end
    else
        if((values_5(1)-values_old_5(1))>2000 || (values_old_5(1)-values_5(1))>2000)
            values_5(1) = values_old_5(1);
        else
            values_old_5(1) = values_5(1);
        end
        if((values_5(2)-values_old_5(2))>2000 || (values_old_5(2)-values_5(2))>2000)
            values_5(2) = values_old_5(2);
        else
            values_old_5(2) = values_5(2);
        end
        if((values_5(3)-values_old_5(3))>2000 || (values_old_5(3)-values_5(3))>2000)
            values_5(3) = values_old_5(3);
        else
            values_old_5(3) = values_5(3);
        end
        if(counter==500)
            values_new_5 = values_5;
        else
            values_new_5 = [values_new_5,values_5];
        end
    end
    
    
    %% Group 6
    a6 = fgetl(mbed6);
    values_6 = sscanf(a6,'%d');
    [n,p] = size(values_6);
    if (counter==0)
        values_old_6 = values_6;
        values_new_6 = values_6;
    elseif(n~=3)
        if(counter==500)
            values_new_6 = values_old_6;
        else
            values_new_6 = [values_new_6, values_old_6];
        end
    else
        if((values_6(1)-values_old_6(1))>2000 || (values_old_6(1)-values_6(1))>2000)
            values_6(1) = values_old_6(1);
        else
            values_old_6(1) = values_6(1);
        end
        if((values_6(2)-values_old_6(2))>2000 || (values_old_6(2)-values_6(2))>2000)
            values_6(2) = values_old_6(2);
        else
            values_old_6(2) = values_6(2);
        end
        if((values_6(3)-values_old_6(3))>2000 || (values_old_6(3)-values_6(3))>2000)
            values_6(3) = values_old_6(3);
        else
            values_old_6(3) = values_6(3);
        end
        if(counter==500)
            values_new_6 = values_6;
        else
            values_new_6 = [values_new_6,values_6];
        end
    end
    
    
    %% Group 7
    a7 = fgetl(mbed7);
    values_7 = sscanf(a7,'%d');
    [n,p] = size(values_7);
    if (counter==0)
        values_old_7 = values_7;
        values_new_7 = values_7;
    elseif(n~=3)
        if(counter==500)
            values_new_7 = values_old_7;
        else
            values_new_7 = [values_new_7, values_old_7];
        end
    else
        if((values_7(1)-values_old_7(1))>2000 || (values_old_7(1)-values_7(1))>2000)
            values_7(1) = values_old_7(1);
        else
            values_old_7(1) = values_7(1);
        end
        if((values_7(2)-values_old_7(2))>2000 || (values_old_7(2)-values_7(2))>2000)
            values_7(2) = values_old_7(2);
        else
            values_old_7(2) = values_7(2);
        end
        if((values_7(3)-values_old_7(3))>2000 || (values_old_7(3)-values_7(3))>2000)
            values_7(3) = values_old_7(3);
        else
            values_old_7(3) = values_7(3);
        end
        if(counter==500)
            values_new_7 = values_7;
        else
            values_new_7 = [values_new_7,values_7];
        end
    end
    
    %% Group 8
    a8 = fgetl(mbed8);
    values_8 = sscanf(a8,'%d');
    [n,p] = size(values_8);
    if (counter==0)
        values_old_8 = values_8;
        values_new_8 = values_8;
    elseif(n~=3)
        if(counter==500)
            values_new_8 = values_old_8;
        else
            values_new_8 = [values_new_8, values_old_8];
        end
    else
        if((values_8(1)-values_old_8(1))>2000 || (values_old_8(1)-values_8(1))>2000)
            values_8(1) = values_old_8(1);
        else
            values_old_8(1) = values_8(1);
        end
        if((values_8(2)-values_old_8(2))>2000 || (values_old_8(2)-values_8(2))>2000)
            values_8(2) = values_old_8(2);
        else
            values_old_8(2) = values_8(2);
        end
        if((values_8(3)-values_old_8(3))>2000 || (values_old_8(3)-values_8(3))>2000)
            values_8(3) = values_old_8(3);
        else
            values_old_8(3) = values_8(3);
        end
        if(counter==500)
            values_new_8 = values_8;
        else
            values_new_8 = [values_new_8,values_8];
        end
    end
    
    %% Other
    %print out the number of counter
    counter
    %sound
    if(counter==1 || counter==500 || counter==1250)
        sound(sin(2*pi*25*(1:4000)/100));
    end
    %create background values
    if(counter==499)
        bg_values_1 = values_new_1;
        bg_values_2 = values_new_2;
        bg_values_3 = values_new_3;
        bg_values_4 = values_new_4;
        bg_values_5 = values_new_5;
        bg_values_6 = values_new_6;
        bg_values_7 = values_new_7;
        bg_values_8 = values_new_8;
    end
    counter=counter+1;
end
%% close serial ports
fclose(mbed1);
fclose(mbed2);
fclose(mbed3);
fclose(mbed4);
fclose(mbed5);
fclose(mbed6);
fclose(mbed7);
fclose(mbed8);
