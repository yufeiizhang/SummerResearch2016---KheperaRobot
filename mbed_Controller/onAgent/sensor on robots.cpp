#include "mbed.h"
 
//Serial pc(USBTX, USBRX);
Serial uart1(p28, p27);
DigitalOut pc_activity(LED2);
char buffer1[5] = {'K',' ','2','\r','\n'};
char buffer2[3] = {'Z','\r','\n'}; 
char buffer_1[10]={0};
uint8_t ind=0;
int co2_1=0;
unsigned int counter=0;
void initialize();//function to initialize the sensor to be polling mode
void report(int number);//function to report


int main() {
    initialize();
    while(1) {
        for(int j=0; j<3; j++)
        {
            uart1.putc(buffer2[j]);         //send command to request data
        }
        while(ind!=10)                      
        //while(buffer_1[ind-1]!=0x0A)
        {
            if(uart1.readable()) 
            {
                buffer_1[ind] = uart1.getc();
                ind++;
            }
        }
        if(counter!=0)
        {
            report(1);
        }
        else
        {
            ind=0;
            co2_1=0;
        }
        printf("%d\n",co2_1);
        pc_activity = !pc_activity;
        co2_1=0;
        counter++;
    }
}
void report(int number)
{
        for (int i=0; i<ind; i++)
        {
        if(buffer_1[i]=='z')break;
        if((buffer_1[i]!='Z') && (buffer_1[i]!=0x20)&&(buffer_1[i]!='\r')&&(buffer_1[i]!='\n'))
        {
            co2_1 = co2_1*10;
            co2_1+=buffer_1[i]-48;
        }
        }
        //pc.printf("co2_%d:%d ppm ",number,co2);
    ind = 0;
    //co2 = 0;
}
void initialize()
{
    for(int i=0; i<5;i++)
        {
            uart1.putc(buffer1[i]);
        }
}