plugin_paths = { "/usr/share/jitsi-meet/prosody-plugins/" }

VirtualHost "sip.___JITSI_HOST___"
    modules_enabled = {
        "limits_exception";
    }
    authentication = "internal_hashed"
