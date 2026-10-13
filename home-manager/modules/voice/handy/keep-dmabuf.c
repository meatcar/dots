#define _GNU_SOURCE
#include <dlfcn.h>
#include <stdlib.h>
#include <string.h>

int setenv(const char *name, const char *value, int overwrite)
{
	static int (*real_setenv)(const char *, const char *, int);

	if (name && strcmp(name, "WEBKIT_DISABLE_DMABUF_RENDERER") == 0)
		return 0;
	if (!real_setenv)
		real_setenv = (int (*)(const char *, const char *, int))dlsym(RTLD_NEXT, "setenv");
	return real_setenv(name, value, overwrite);
}
