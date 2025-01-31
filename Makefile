-include $(shell curl -sSL -o .build-harness "https://cloudposse.tools/build-harness"; echo .build-harness)

all: init docs/terraform.md readme

test::
	@echo "🚀 Starting tests..."
	./test/run.sh
	@echo "✅ All tests passed."
