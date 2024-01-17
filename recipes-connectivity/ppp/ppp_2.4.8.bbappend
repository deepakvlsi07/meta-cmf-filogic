DEPENDS_remove = "virtual/crypt"
DEPENDS_append = " nanomsg"
DEPENDS_append_broadband = " libxcrypt"

SRC_URI_remove = "${@bb.utils.contains('DISTRO_FEATURES', 'rdkb_xdsl_ppp_manager', ' ', 'file://ipc-event.patch', d)}"
SRC_URI_remove = "${@bb.utils.contains('DISTRO_FEATURES', 'rdkb_xdsl_ppp_manager', ' ', 'file://ppp-remote-local-samelinklocaladdresses-fix.patch', d)}"
SRC_URI_remove = "${@bb.utils.contains('DISTRO_FEATURES', 'rdkb_xdsl_ppp_manager', ' ', 'file://ppp-sessionBW-authProtocol-ACName-LastConnErr-DM-Impl.patch', d)}"
