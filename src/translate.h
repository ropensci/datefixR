#include <R.h>  /* to include Rconfig.h */

#if defined(ENABLE_NLS) && !defined(_WIN32)
#include "libintl.h"
#define _(String) dgettext ("datefixR", String)
#else
#define _(String) (String)
#endif
