
CENTOS7_BASE_ISO=CentOS-7-x86_64-Minimal-1611.iso
CENTOS7_BASE_ISO_URL=http://mirrors.aliyun.com/centos/7/isos/x86_64/$(CENTOS7_BASE_ISO)
CENTOS7_BASE_ISO_SHA256=27bd866242ee058b7a5754e83d8ee8403e216b93d130d800852a96f41c34d86a

CUSTOM_ISO=CentOS-7-Custom-$(shell date +%y%m%d).iso


isofs/c7dev.cfg

isofs:
	umount isofs_temp || echo -n ""
	rm -fr isofs isofs_temp
	mkdir -p isofs isofs_temp
	mount -o loop $(CENTOS7_BASE_ISO) isofs_temp
	cp -fr isofs_temp/* isofs
	umount isofs_temp
	rm -fr isofs_temp


$(CENTOS7_BASE_ISO): CHECK_ISO_CHECKSUM
	@if [ -f $(CENTOS7_BASE_ISO) ] ; then \
		echo "$(CENTOS7_BASE_ISO) is already downloaded." ; \
	else \
		echo wget $(CENTOS7_BASE_ISO_URL) -O $(CENTOS7_BASE_ISO) ; \
	fi

CHECK_ISO_CHECKSUM:
	@if [ -f $(CENTOS7_BASE_ISO) ] ; then \
		sum=$(shell sha256sum $(CENTOS7_BASE_ISO) | awk '{print $$1}') ; \
		if [ "$$sum" != "$(CENTOS7_BASE_ISO_SHA256)" ] ; then \
			echo 'checksum for $(CENTOS7_BASE_ISO) is invalid, delete it.' ; \
			rm -frv $(CENTOS7_BASE_ISO) ; \
		fi ; \
	fi


.PHONY: CHECK_ISO_CHECKSUM isofs
