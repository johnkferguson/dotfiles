.PHONY: switch clean

switch:
	home-manager switch --flake .#${USER}

clean:
	nix-collect-garbage -d
