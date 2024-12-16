.PHONY: mix-setup npm-install pip-install setup

mix-setup:
	@echo "Running setting up Mix..."
	./setup_mix.sh

npm-install:
	@echo "Running setting up JS libraries..."
	./init_setup_script/npm_install.sh

pip-install:
	@echo "Running setting up Python libraries..."
	./init_setup_script/pip_install.sh

setup: mix-setup npm-install pip-install
