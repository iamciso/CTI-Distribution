.PHONY: build clean check lint

build:
	cd live-build && sudo lb build 2>&1 | tee build.log

clean:
	cd live-build && sudo lb clean --purge

check:
	tests/check-packages.sh

lint:
	shellcheck live-build/auto/* live-build/config/hooks/normal/*.hook.chroot \
	  live-build/config/includes.chroot/usr/local/bin/* tests/*.sh tools/stacks/*.sh
