install:
	pip install flake8

check:
	git diff --name-only --cached | grep '\.py$' | xargs flake8 --select=F --ignore=E,W,C
	git diff --name-only | grep '\.py$' | xargs flake8 --select=F --ignore=E,W,C
	# git diff --name-only HEAD | grep '\.py$' | xargs flake8
	# git ls-files -mo | grep '\.py$' | xargs flake8
