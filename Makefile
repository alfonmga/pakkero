all:
	cp lib/packngo/Obfuscation.go lib/packngo/Obfuscation.go.bak;
	sed -i "s|LAUNCHERSTUB|$$(base64 -w0 data/Launcher.go)|g" lib/packngo/Obfuscation.go;
	go build -i \
		-gcflags="-N" \
		-gcflags="-nolocalimports" \
		-gcflags="-pack" \
		-gcflags="-trimpath=." \
		-asmflags="-trimpath=." \
		-gcflags="-trimpath=$$GOPATH/src/" \
		-asmflags="-trimpath=$$GOPATH/src/" \
		-ldflags="-s" \
		-o dist/packngo; mv lib/packngo/Obfuscation.go.bak lib/packngo/Obfuscation.go
	strip \
		-sxX \
		--remove-section=.bss \
		--remove-section=.comment \
		--remove-section=.eh_frame \
		--remove-section=.eh_frame_hdr \
		--remove-section=.fini \
		--remove-section=.fini_array \
		--remove-section=.gnu.build.attributes \
		--remove-section=.gnu.hash \
		--remove-section=.gnu.version \
		--remove-section=.got \
		--remove-section=.note.ABI-tag \
		--remove-section=.note.gnu.build-id \
		--remove-section=.note.go.buildid \
		--remove-section=.shstrtab \
		--remove-section=.typelink \
		dist/packngo;
clean:
	rm -rf dist/;
	cp lib/packngo/Obfuscation.go lib/packngo/Obfuscation.go.bak;
	sed -i "s|LAUNCHERSTUB|$$(base64 -w0 data/Launcher.go)|g" lib/packngo/Obfuscation.go;
	go build -i \
		-gcflags="-N" \
		-gcflags="-nolocalimports" \
		-gcflags="-pack" \
		-gcflags="-trimpath=." \
		-asmflags="-trimpath=." \
		-gcflags="-trimpath=$$GOPATH/src/" \
		-asmflags="-trimpath=$$GOPATH/src/" \
		-ldflags="-s" \
		-o dist/packngo; mv lib/packngo/Obfuscation.go.bak lib/packngo/Obfuscation.go
	strip \
		-sxXwSgd \
		--remove-section=.bss \
		--remove-section=.comment \
		--remove-section=.eh_frame \
		--remove-section=.eh_frame_hdr \
		--remove-section=.fini \
		--remove-section=.fini_array \
		--remove-section=.gnu.build.attributes \
		--remove-section=.gnu.hash \
		--remove-section=.gnu.version \
		--remove-section=.got \
		--remove-section=.note.ABI-tag \
		--remove-section=.note.gnu.build-id \
		--remove-section=.note.go.buildid \
		--remove-section=.shstrtab \
		--remove-section=.typelink \
		dist/packngo

test: clean
	dist/packngo \
		--file /usr/bin/echo \
		-o /tmp/test.enc \
		-offset 1850000 \
		-register-dep /usr/bin/bash;
	sync;
	for i in $$(seq 1 500); do /tmp/test.enc $$i; done;
