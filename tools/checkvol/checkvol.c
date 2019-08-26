#include <unistd.h>
#include <fcntl.h>

#ifdef OSSCONTROL
#define MIXER_DEV "/dev/dsp"

#include <sys/soundcard.h>
#include <sys/ioctl.h>
#include <stdio.h>
#else
#include <alsa/asoundlib.h>
#endif


typedef enum {
    AUDIO_VOLUME_SET,
    AUDIO_VOLUME_GET,
} audio_volume_action;

/*
  Drawbacks. Sets volume on both channels but gets volume on one. Can be easily adapted.
 */
int audio_volume(audio_volume_action action, long* outvol)
{
    int ret = 0;
#ifdef OSSCONTROL
    int ret = 0;
    int fd, devs;

    if ((fd = open(MIXER_DEV, O_WRONLY)) > 0)
    {
        if(action == AUDIO_VOLUME_SET) {
            if(*outvol < 0 || *outvol > 100)
                return -2;
            *outvol = (*outvol << 8) | *outvol;
            ioctl(fd, SOUND_MIXER_WRITE_VOLUME, outvol);
        }
        else if(action == AUDIO_VOLUME_GET) {
            ioctl(fd, SOUND_MIXER_READ_VOLUME, outvol);
            *outvol = *outvol & 0xff;
        }
        close(fd);
        return 0;
    }
    return -1;;
#else
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
    /* fprintf(stderr, "Volume range <%i,%i>\n", minv, maxv); */

    if(snd_mixer_selem_get_playback_volume(elem, 0, outvol) < 0) {
	snd_mixer_close(handle);
	return -6;
    }

    /* fprintf(stderr, "Get volume %i with status %i\n", *outvol, ret); */
    /* make the value bound to 100 */
    *outvol -= minv;
    maxv -= minv;
    minv = 0;
    *outvol = 100 * (*outvol) / maxv; // make the value bound from 0 to 100

    snd_mixer_close(handle);
    return 0;
#endif
    }

int main(void)
{
    long vol = -1;
    audio_volume(AUDIO_VOLUME_GET, &vol);
    vol++; // since this is for some reason of by one percent
    /* printf("Ret %i\n", audio_volume(AUDIO_VOLUME_GET, &vol)); */
    printf("%ld%%", vol);

    vol = 100;
    /* printf("Ret %i\n", audio_volume(AUDIO_VOLUME_SET, &vol)); */

    return 0;
}
