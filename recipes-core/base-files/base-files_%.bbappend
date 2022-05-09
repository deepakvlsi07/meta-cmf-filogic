do_install_append_broadband () {
	# deal with hostname
	if [ "${hostname}" ]; then
		echo "Filogic-GW" > ${D}${sysconfdir}/hostname
		echo "127.0.1.1 Filogic-GW" >> ${D}${sysconfdir}/hosts
	fi
}
