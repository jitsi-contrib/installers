plugin_paths = { "/usr/share/jitsi-meet/prosody-plugins/" }

VirtualHost "recorder.___JITSI_HOST___"
    modules_enabled = {
        "limits_exception";
    }
    authentication = "internal_hashed"
