#include <R.h>  /* to include Rconfig.h */

#ifdef ENABLE_NLS
#include "libintl.h"
#define _(String) dgettext ("datefixR", String)
/* replace pkg as appropriate */
#else
#define _(String) (String)
#endif