all: default experimental

BOARDS =                \
	EZ/ErgoDox            \
	Keyboardio/Atreus     \
	Keyboardio/Model01    \
	SOFTHRUF/Splitography \
	Technomancy/Atreus

default: message/default dirs   \
	$(foreach board,${BOARDS},${board}@default)

experimental: message/experimental dirs \
	$(foreach board,${BOARDS},${board}@experimental)

${BOARDS}:
	${MAKE} $@@default $@@experimental

## The experimental firmware are optional, don't fail if we can't find any.
.IGNORE: $(foreach board,${BOARDS},${board}@experimental)

dirs:
	install -d output

message/%:
	echo "Building $* firmware sketches" | sed -e "s,.,=,g"
	echo "Building $* firmware sketches"
	echo "Building $* firmware sketches" | sed -e "s,.,=,g"
	echo

%@default: BUILDDIR := $(shell mktemp -d)
%@default:
	${MAKE} -C $*/default build \
		KALEIDOSCOPE_OUTPUT_PATH=${BUILDDIR} SKETCH_OUTPUT_DIR="default"
	install -d output/$*
	cp -L ${BUILDDIR}/default/*-latest.hex output/$*/default.hex
	rm -rf "${BUILDDIR}"

%@experimental: BUILDDIR := $(shell mktemp -d)
%@experimental:
	${MAKE} -C $*/experimental build \
		KALEIDOSCOPE_OUTPUT_PATH=${BUILDDIR} SKETCH_OUTPUT_DIR="experimental"
	install -d output/$*
	cp -L ${BUILDDIR}/experimental/*-latest.hex output/$*/experimental.hex
	rm -rf "${BUILDDIR}"

clean:
	rm -rf output
	find . -type d -name 'output' | xargs rm -rf

.SILENT:
.PHONY: ${BOARDS}
