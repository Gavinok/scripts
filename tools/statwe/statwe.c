#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>
#include <alsa/asoundlib.h>

#define PATH_MAX 100
#define VERSION 0.1
#define LEN(x) (sizeof (x) / sizeof *(x))
char buf[1024];


int audio_volume(long* outvol)
{
    int ret = 0;
    snd_mixer_t* handle;
    snd_mixer_elem_t* elem;
    snd_mixer_selem_id_t* sid;

    static const char* mix_name = "Master";
    static const char* card = "default";
    static int mix_index = 0;

    long pmin, pmax;
    long get_vol, set_vol;
    float f_multi;

    snd_mixer_selem_id_alloca(&sid);

    //sets simple-mixer index and name
    snd_mixer_selem_id_set_index(sid, mix_index);
    snd_mixer_selem_id_set_name(sid, mix_name);

    if ((snd_mixer_open(&handle, 0)) < 0)
	return -1;
    if ((snd_mixer_attach(handle, card)) < 0) {
	snd_mixer_close(handle);
	return -2;
    }
    if ((snd_mixer_selem_register(handle, NULL, NULL)) < 0) {
	snd_mixer_close(handle);
	return -3;
    }
    ret = snd_mixer_load(handle);
    if (ret < 0) {
	snd_mixer_close(handle);
	return -4;
    }
    elem = snd_mixer_find_selem(handle, sid);
    if (!elem) {
	snd_mixer_close(handle);
	return -5;
    }

    long minv, maxv;

    snd_mixer_selem_get_playback_volume_range (elem, &minv, &maxv);

    if(snd_mixer_selem_get_playback_volume(elem, 0, outvol) < 0) {
	snd_mixer_close(handle);
	return -6;
    }

    /* make the value bound to 100 */
    *outvol -= minv;
    maxv -= minv;
    minv = 0;
    *outvol = 100 * (*outvol) / maxv; // make the value bound from 0 to 100

    snd_mixer_close(handle);
    return 0;
}

const char * datetime(const char *fmt)
{
    time_t t;

    t = time(NULL);
    if (!strftime(buf, sizeof(buf), fmt, localtime(&t))) {
	/* warn("strftime: Result string exceeds buffer size"); */
	return NULL;
    }

    return buf;
}

const char *filetostring(const char *file)
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
	return buffer;
    }
    printf("failed to parse file");
    return NULL;
}

const char * battery_print(int perc, int charging)
{
    /* printf("state %d\n", charging); */
    if (charging)
	return "|🗲|";
	/* return "|🗲|"; */
    if ( perc <= 5)
	return "|!|";
    else if (perc >= 80)
	return "|▇|";
    else if (perc >= 60)
	return "|▅|";
    else if (perc >= 40)
	return "|▃|";
    else if (perc >= 20)
	return "|▂|";
    else
	return "|▁|";
}

int battery_perc(const char *bat)
{
    int perc = -1;
    char path[PATH_MAX];

    if (snprintf(path, sizeof(path), "/sys/class/power_supply/%s/capacity", bat) < 0) {
	return -1;
    }
    const char *percstr = filetostring(path);
    perc = atoi(percstr); 
    return perc;

}

int battery_state(const char *bat){

    /* int state = -1; */
    int charging = 1;
    char path[PATH_MAX];

    if (snprintf(path, sizeof(path), "/sys/class/power_supply/%s/status", bat) < 0) {
	return -1;
    }

    const char *state = filetostring(path);
    if (strncmp(state, "Discharging", 3) == 0)
	charging = 0;
    else if (strncmp(state, "Charging", 3) == 0)
	charging = 1;
    return charging;
}

const char * battery_bar(const char *bat)
{
    int perc = battery_perc(bat);
    int state = battery_state(bat);


    if (perc < 0) {
	return "error assesing battery level";
    }
    if (state < 0) {
	return "error assesing state";
    }

    /* state */
    return battery_print(perc, state);
}

float brightness()
{
    const char *filename = "/sys/class/backlight/intel_backlight/brightness";
    const char *file2name = "/sys/class/backlight/intel_backlight/max_brightness";
    int currentbrightness = atoi(filetostring(filename));    
    int maxbrightness = atoi(filetostring(file2name));    
    if(maxbrightness == 0  || currentbrightness == 0){
	printf("error retreiving brightness percentage\n");
	return -1;
    }
    float percentbrightness = ((float)currentbrightness/maxbrightness)*100;
    return percentbrightness;
}

int termals(const char *file)
{
    /* uintmax_t temp; */
    int temp;
    temp = atoi(filetostring(file));    
    temp = temp/1000;

    return temp;
}

    /* int */
/* pscanf(const char *path, const char *fmt, ...) */
/* { */
/*     FILE *fp; */
/*     va_list ap; */
/*     int n; */
/*  */
/*     if (!(fp = fopen(path, "r"))) { */
/* 	#<{(| warn("fopen '%s':", path); |)}># */
/* 	return -1; */
/*     } */
/*     #<{(| va_start(ap, fmt); |)}># */
/*     #<{(| n = vfscanf(fp, fmt, ap); |)}># */
/*     #<{(| va_end(ap); |)}># */
/*     fclose(fp); */
/*  */
/*     return (n == EOF) ? -1 : n; */
/* } */
/*  */
/*     const char * */
/* fmt_human(int num, int base) */
/* { */
/*     double scaled; */
/*     size_t i, prefixlen; */
/*     const char **prefix; */
/*     const char *prefix_1000[] = { "", "k", "M", "G", "T", "P", "E", "Z", */
/* 	"Y" }; */
/*     const char *prefix_1024[] = { "", "Ki", "Mi", "Gi", "Ti", "Pi", "Ei", */
/* 	"Zi", "Yi" }; */
/*  */
/*     switch (base) { */
/* 	case 1000: */
/* 	    prefix = prefix_1000; */
/* 	    prefixlen = LEN(prefix_1000); */
/* 	    break; */
/* 	case 1024: */
/* 	    prefix = prefix_1024; */
/* 	    prefixlen = LEN(prefix_1024); */
/* 	    break; */
/* 	default: */
/* 	    #<{(| warn("fmt_human: Invalid base"); |)}># */
/* 	    return NULL; */
/*     } */
/*  */
/*     scaled = num; */
/*     for (i = 0; i < prefixlen && scaled >= base; i++) { */
/* 	scaled /= base; */
/*     } */
/*  */
/*     char *buffer = NULL; */
/*     sprintf(buffer, "%.1f%s", scaled, prefix[i]); */
/*     return buffer; */
/* } */

/* float ram_used(void) */
/* { */
/*     int total, free, buffers, cached; */
/*  */
/*     const char *buf = filetostring("/proc/meminfo"); */
/*     printf("%s\n", buf); */
/*     if (sscanf(buf, */
/* 		"MemTotal: %d kB\n" */
/* 		"MemFree: %d kB\n" */
/* 		"MemAvailable: %d kB\n" */
/* 		"Buffers: %d kB\n" */
/* 		"Cached: %d kB\n", */
/* 		&total, &free, &buffers, &buffers, &cached) != 5) { */
/* 	return -1; */
/*     } */
/*  */
/*     #<{(| return fmt_human((total - free - buffers - cached) * 1024, |)}># */
/*     #<{(|     1024); |)}># */
/*     return (float)((total - free - buffers - cached) * 1024); */
/* } */

static void usage(void)
{
	fputs("usage: statwe [-bavh] \n", stderr);
	exit(1);
}
int main(int argc, char *argv[])
{
    int batperc = battery_perc("BAT0");
    const char * date = datetime("%a, %b %d %I:%M%p");
    const char * bar = battery_bar("BAT0");
    int temp = termals("/sys/class/hwmon/hwmon1/temp1_input");
    for (int i = 1; i < argc; i++){
	/* these options take no arguments */
	if (!strcmp(argv[i], "-b")){
	    float brightperc = brightness();
	    printf("light: %.0f%% [%d°] %s %s%d%% \n", brightperc, temp, date, bar, batperc);
	    return 0;
	}//update brightness
	/* else if (!strcmp(argv[i], "-v")) {      #<{(| prints version information |)}># */
	/*     puts("statwe-"VERSION); */
	/*     exit(0); */
	/* } */
	else if (!strcmp(argv[i], "-a")){
	    //update audio volume
	    long vol = -1;
	    audio_volume(&vol);
	    vol++; // since this is for some reason of by one percent
	    printf("Vol: %ld%% [%d°] %s %s%d%% \n", vol, temp, date, bar, batperc);
	    return 0;
	} else if (!strcmp(argv[i], "-h")) 
	    usage();
    }
    printf("[%d°] %s %s%d%% \n", temp, date, bar, batperc);
    /* printf("[%d°] %s %s%d%% \n", temp, date, bar, batperc); */
    return 0;
}
