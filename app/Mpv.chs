{-# LANGUAGE ForeignFunctionInterface #-}
{-# OPTIONS_GHC -Wno-all #-}

module Mpv where

import Foreign.C.String (CString)
import Foreign.Marshal.Utils
import Foreign.Ptr (Ptr)

#include <mpv/client.h>

data MpvHandle

{# context prefix = "mpv" #}

{# pointer *handle as MpvHandlePtr -> MpvHandle #}

{# fun pure client_api_version as ^ { } -> `Int' #}

{# fun create as ^ { } -> `MpvHandlePtr' #}

{# fun error_string as ^ { `Int' } -> `CString' #}

{# fun initialize as ^ { `MpvHandlePtr' } -> `Int' #}

{# fun destroy as ^ { `MpvHandlePtr' } -> `()' #}

{# fun terminate_destroy as ^ { `MpvHandlePtr' } -> `()' #}

{# fun set_option_string as ^ { `MpvHandlePtr', `String', `String' } -> `Int' #}

{# fun command as ^ { `MpvHandlePtr', id `Ptr CString' } -> `Int' #}
