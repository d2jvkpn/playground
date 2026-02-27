run:
	python3 mdns_advertise.py

verify:
	avahi-browse -rt _demo._tcp

verify_on_mac:
	dns-sd -B _demo._tcp
	dns-sd -L MyDemoService _demo._tcp
