/*codes for khepera iv robot*/
/*use eclipse cross-compiler*/
/*reading data from matlab  */

/*suitable for 28/29/121 three robot*/


/*1encoder=0.000675m/s=0.675mm/s*/
/*=============================*/
/*INCLUDE****/
#include <khepera/khepera.h>
#include <signal.h>//Ctrl-C handler
// kb_socket.h / kb_khepera4.h
// Are included

/*=============================*/
/*DEFINE****/
/*Motor Setting*/
//Motor
#define _POS_MARGIN_ 20
#define _ACC_INCEMENT_ 3
#define _ACC_DIVIDER_ 0
#define _MIN_SPEED_ACC_ 20
#define _MIN_SPEED_DEC_ 1
#define _MAX_SPEED_ 400
//PID
#define _PID_P_ 35
#define _PID_I_ 5
#define _PID_D_ 10
/*Server Setting*/
#define _SERVER_PORT_ 344
/*LENGTH OF INSTRUCTION FROM MATLAB*/
#define _INS_LENGTH_ 10
/*Actuator waiting time - ms */
#define _SLEEPTIME_ 10000

/*=============================*/
/*GLOBAL DECLARATION****/
/*knet I2C Sockets*/
static knet_dev_t *dsPic;
/*Motor Position*/
int leftMotPos = 0;//Unit should be encoders here
int rightMotPos = 0;
/*ksock Server*/
ksock_t server;
int serverPort = _SERVER_PORT_;
int clntSocket = 0;
/*Quit Request*/
int quitReq = 1;
/*STRUCT FOR FUNCTION*/
struct Speed
{
	int left;
	int right;
	int flag;
};

/*=============================*/
/*FUNCTION DECLARATION****/
extern void cTrlcHandler( int );
extern void loopFrame( int );
extern struct Speed dataReceiver( int );

/*=============================*/
/*MAIN FUNCTION****/
int main(int argc, char *argv[]) {
	/*VARIABLE DECLARATION*/
	int kbIniMarker;
	int reVal = 0;//General Return Value
	int counter = 1;

	/*-----------------*/
	/*ERASE SCREEN*/
	kb_clrscr();
	/*INITIALIZE ACTUATOR SYSTEM*/
	printf("Initiate Khepera IV Actuator System!\r\n");
	kb_set_debug_level(2);
	printf("LibKhepera Initiate...\r\n");
	if ( ( kbIniMarker = kb_init( argc , argv ) ) < 0 )
	{
		printf("Initiate Error!\r\nERROR 01\r\n");
		return -1;
	}
	/*INITIALIZE VARIOUS HANDLE*/
	printf("Initiate Bus Handle...\r\n");
	dsPic = knet_open( "Khepera4:dsPic" , KNET_BUS_I2C , 0 , NULL );
	if ( dsPic == NULL )
	{
		printf("Initiate Socket Error!\r\nERROR 02\r\n");
		return -2;
	}
	/*SET POSITION MARGIN*/
	printf("Set Motor Configuration...\r\n");
	kh4_SetPositionMargin( _POS_MARGIN_ , dsPic );
	/*SET PID CONFIGURATION*/
	kh4_ConfigurePID( _PID_P_ , _PID_I_ , _PID_D_ , dsPic );
	/*Remark of PID part: */
	/*As describe in documents, the parameters should be char instead of int*/
	/*SET ACCELERATION*/
	kh4_SetSpeedProfile( _ACC_INCEMENT_ , _ACC_DIVIDER_ , _MIN_SPEED_ACC_ , _MIN_SPEED_DEC_, _MAX_SPEED_ , dsPic );
	/*Same Remark as PID part, these parameters should be char*/
	/*Set MOTOR IDLE*/
	kh4_SetMode( kh4RegIdle , dsPic );
	/*GET INITIAL MOTOR POSITION*/
	printf("Read Motor Initial Position...\r\n");
	/*Reset Position Encoder First*/
	reVal = kh4_ResetEncoders( dsPic );
	if ( reVal < 0 )
	{
		printf("Reset Position Error.\r\nERROR 04\r\n");
		return -4;
	}
	reVal = kh4_get_position( &leftMotPos , &rightMotPos , dsPic );
	if ( reVal < 0 )
	{
		printf("Read Position Error.\r\nERROR 05\r\n");
		return -5;
	}
	else
	{
		printf( "The Position of Left Motor: \t%d\r\n", leftMotPos );
		printf( "The Position of right Motor: \t%d\r\n", rightMotPos );
	}

	/*-----------------*/
	/*INITIALIZE SERVER*/
	printf("Initialize Khepera IV Server System...\r\n");
	printf("Waiting for MATLAB...\r\n");
	if ( ( kbIniMarker = ksock_init() ) < 0 )
	{
		printf("Initiate Error!\r\nERROR 06\r\n");
		return -6;
	}
	/*START SERVER*/
	reVal = ksock_server_open( &server , serverPort );
	/*COMMUNICATION HANDLER*/
	clntSocket = ksock_next_connection( &server );
	if ( reVal < 0 )
	{
		printf("Initiate Server Error.\r\nERROR 07\r\n");
		return -7;
	}
	/*PRINT SERVER INFORMATION*/
	printf("SerVer Information:\r\n");
	printf("\tIP Address:\t%s\r\n",inet_ntoa(server.serv_addr.sin_addr));//ERROR?
	printf("\tPort Num:\t%d\r\n",serverPort);

	/*-----------------*/
	/*MAIN LOOP*/
	/*SET CTRL-C SIGNAL*/
	signal( SIGINT , cTrlcHandler );
	/*LOOP*/
	printf("System online.\r\n");
	counter = 1;
	quitReq = 1;
	while( quitReq )
	{
		//quitReq = 0;//test
		printf("No.%d Frame.\r\n",counter);
		loopFrame( counter );
		counter++;
	}
	/*-----------------*/
	/*CLEAN UP*/
	printf("Turn off the Khepera...\r\n");
	/*STOP AGENT*/
	kh4_set_speed( 0 , 0 , dsPic );
	kh4_SetMode( kh4RegIdle , dsPic );
	/*TURN OFF LEDS*/
	kh4_SetRGBLeds( 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , dsPic );
	/*CLEAN ALL SUB-LAYER*/
	kb_exit();
	printf("All Set.\r\n");
	/*RETURN*/
	return 0;
}

/*=============================*/
/*CTRL-C HANDLER FUNCTION****/
void cTrlcHandler( int sig )
{
	/*QUIT REQUEST - GLOBAL*/
	quitReq = 0;
	/*CLEAN UP*/
	kh4_set_speed( 0 , 0 , dsPic );
	kh4_SetMode( kh4RegIdle , dsPic );
	kh4_SetRGBLeds( 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , dsPic );
	/*RETURN*/
	return;
}

/*=============================*/
/*LOOP FRAME FUNCTION****/
void loopFrame( int counter )
{

	/*DECLARITION*/
	struct Speed data;
	int lspeed = 0;
	int rspeed = 0;
	/*GET DATA FROM MATLAB*/
	data = dataReceiver( clntSocket );
	lspeed = data.left;
	rspeed = data.right;
	if ( data.flag == 9 )
		return;
	/*ACTUATE*/
	/*SET MOTOR MODE*/
	kh4_SetMode( kh4RegSpeed , dsPic );
	kh4_set_speed( lspeed , rspeed , dsPic );// robot 60 is different here
	usleep(_SLEEPTIME_);
	/*CHECK SPEED*/
	kh4_get_speed( &lspeed , &rspeed ,dsPic);
	printf("Check Motor Speed:\r\n");
	printf("\tLeft:\t%d,\tRight:\t%d\r\n",lspeed,rspeed);
	return;
}

/*=============================*/
/*DATA RECEIVER FUNCTION****/
/*DATA SHOULD BE LIKE:     */
/*       L+345R-890        */
struct Speed dataReceiver( int clntSocket )
{
	/*DECLARITION*/
	struct Speed result;
	int digitCounter = 1;
	int dataLeft = 0;
	int dataRight = 0;
	int signLeft = 1;
	int signRight = 1;
	static int char0 = (int)'0';
	/*DEFAULT RESULT*/
	result.flag=0;
	result.left=0;
	result.right=0;
	/*RECEIVE DATA FROM MATLAB*/
	while( digitCounter<= _INS_LENGTH_ )
	{
		char reByte;
		int recvLen = 0;
		if ( digitCounter == 1 )
		{
			dataLeft = 0;
			dataRight = 0;
		}
		recvLen = recv( clntSocket , &reByte , 1 , 0 );
		printf("%c\r",reByte);
		if ( recvLen != 1 )
			continue;
		switch ( digitCounter )
		{
			case 1:
				/*Normal*/
				if ( reByte != 'L' )
					digitCounter = 1;
				/*Stop Sign from MATLAB*/
				if ( reByte == 'S' )
				{
					quitReq = 0;
					result.left = 0;
					result.right = 0;
					result.flag = 9;//quit request
					return result;
				}
				break;
			case 2:
				if ( reByte == '-')
					signLeft = -1;
				/*else the number is positive*/
				break;
			case 3:
			case 4:
			case 5:
				if ( isdigit( reByte ) )
					dataLeft = dataLeft * 10 + (int)reByte - char0;
				else
					digitCounter = 1;
				break;
			case 6:
				if ( reByte != 'R' )
					digitCounter = 1;
				break;
			case 7:
				if ( reByte == '-')
					signRight = -1;
				/*else the number is positive*/
				break;
			case 8:
			case 9:
			case 10:
				if ( isdigit( reByte ) )
					dataRight = dataRight * 10 + (int)reByte - char0;
				else
					digitCounter = 1;
				break;
			default:
				dataLeft = 0;
				dataRight = 0;
				printf("Counter Error @ Function dataReceiver. \r\n");
				printf("ERROR 08\r\n");
				printf("Set Motor Idle: L = 0 , R = 0\r\n");
				result.left = dataLeft;
				result.right = dataRight;
				result.flag = -8;
				return result;
		}
		digitCounter++;
	}
	/*UPDATE DATA*/
	result.left = signLeft * dataLeft;
	result.right = signRight * dataRight;
	result.flag = 0;
	/*PRINT DATA*/
	printf("DATA RECEIVED FROM MATLAB:\r\n");
	printf("\tL:%d,\tR:%d\r\n",result.left,result.right);
	return result;
}

