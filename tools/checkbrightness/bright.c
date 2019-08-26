#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int inttofile(int newval)
{
    char snum[15];
    sprintf(snum, "%d", newval);
    /* printf("%s", snum); */

    /* FILE *fp; */
    /* char filename[100]; */
    /* char writestr[100]; */
    /*  */
    /* // Read filename */
    /* printf("Enter a filename :"); */
    /* gets(filename); */
    /*  */
    /* // Read string to write */
    /* printf("Enter the string to write :"); */
    /* gets(writestr); */
    /*  */
    /* // Open file in write mode */
    /* fp = fopen(filename,"w+"); */
    /*  */
    /* // If file opened successfully, then write the string to file */
    /* if ( fp ) */
    /* { */
	/*    fputs(writestr,fp); */
    /* } */
    /* else */
    /*   { */
	/*  printf("Failed to open the file\n"); */
	/* } */
    /* //Close the file */
    /* fclose(fp); */
}

int filetoint(const char *file)
{
    char *buffer = 0;
    long length;
    FILE *f = fopen(file, "rb");

    if (f)
    {
      fseek(f, 0, SEEK_END);
      length = ftell(f);
      fseek(f, 0, SEEK_SET);
      buffer = malloc(length);
      if(buffer)
      {
	fread (buffer, 1, length, f);
      }
      fclose(f);
    }

    if(buffer)
    {
	int num = atoi(buffer);
	return num;
    }
    return 0;
}
int main(int argc, char *argv[])
{
    /* int counter;  */
    /* printf("Program Name Is: %s",argv[0]);  */
    /* if(argc==1)  */
    /*     printf("\nNo Extra Command Line Argument Passed Other Than Program Name");  */
    /* if(argc>=2)  */
    /* {  */
    /*     printf("\nNumber Of Arguments Passed: %d",argc);  */
    /*     printf("\n----Following Are The Command Line Arguments Passed----");  */
    /*     for(counter=0;counter<argc;counter++)  */
    /*         printf("\nargv[%d]: %s",counter,argv[counter]);  */
    /* }  */

    const char *filename = "/sys/class/backlight/intel_backlight/brightness";
    const char *file2name = "/sys/class/backlight/intel_backlight/max_brightness";
    int currentbrightness = filetoint(filename);    
    int maxbrightness = filetoint(file2name);    
    if(currentbrightness == 0){
    	printf("0%%");
    	return 0;
    }
    if(maxbrightness == 0)
	   return 1;
    float percentbrightness = ((float)currentbrightness/maxbrightness)*100;
    inttofile((int)percentbrightness);
    printf ("%.0f%%", percentbrightness);
    return 0;
}
