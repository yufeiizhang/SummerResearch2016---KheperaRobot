#include "mbed.h"
Serial uart1(p28, p27);
Serial uart2(p13 ,p14);
Serial uart3(p9, p10);
Serial pc(USBTX, USBRX);
char read_co2[7] = {0xFE,0x44,0x00,0x08,0x02,0x9F,0x25};
char response_1[7]={0,0,0,0,0,0,0};
char response_2[7]={0,0,0,0,0,0,0};
char response_3[7]={0,0,0,0,0,0,0};
int valMultiplier = 1;
void sendRequest(char packet[],int number);
unsigned long get_value(char packet[]);
unsigned long co2_1,co2_2,co2_3,co2_11,co2_22,co2_33;
int main()
{
    while(1)
    {
        sendRequest(read_co2,1);
        co2_1 = get_value(response_1);
        if(co2_1 > 10000)
        {
            co2_1 = co2_11;
        }
        else
        {
            co2_11 = co2_1;
        }
        //pc.printf("1:%d ",val_co2);
        sendRequest(read_co2,2);
        co2_2 = get_value(response_2);
        if(co2_2 > 10000)
        {
            co2_2 = co2_22;
        }
        else
        {
            co2_22 = co2_2;
        }
        //pc.printf("2:%d ",val_co2);
        sendRequest(read_co2,3);
        co2_3 = get_value(response_3);
        if(co2_3 > 10000)
        {
            co2_3 = co2_33;
        }
        else
        {
            co2_33 = co2_3;
        }
        //pc.printf("3:%d\r\n",val_co2);
        pc.printf("%d %d %d\n",co2_1,co2_2,co2_3);
    }
}

void sendRequest(char packet[], int number)
{
        if(number==1)
        {
            while(!uart1.readable())
            {   
                for (int i=0;i<7;i++)
                {
                    if(uart1.writeable())
                    {
                        uart1.putc(read_co2[i]);
                    }
                }
                wait(0.1);
            }
            
            for (int j=0;j<7;j++)
            {
                if(uart1.readable())
                {
                response_1[j] = uart1.getc();
                }
            }
        }
        if(number==2)
        {
             while(!uart2.readable())
            {   
                for (int i=0;i<7;i++)
                {
                    if(uart2.writeable())
                    {
                        uart2.putc(read_co2[i]);
                    }
                }
                wait(0.1);
            }
            
            for (int j=0;j<7;j++)
            {
                if(uart2.readable())
                {
                response_2[j] = uart2.getc();
                }
            }
        }
        if(number==3)
        {
             while(!uart3.readable())
            {   
                for (int i=0;i<7;i++)
                {
                    if(uart3.writeable())
                    {
                        uart3.putc(read_co2[i]);
                    }
                }
                wait(0.1);
            }
            
            for (int j=0;j<7;j++)
            {
                if(uart3.readable())
                {
                response_3[j] = uart3.getc();
                }
            }
        }
}

unsigned long get_value(char packet[])
{
    int high = packet[3];
    
    int low = packet[4];
    
    unsigned long val = high*256 + low;
    return val*valMultiplier;
}

    