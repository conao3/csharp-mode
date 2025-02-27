EMACS ?= emacs
CASK ?= cask

TESTHOME=/tmp/emacs

package: build
	$(CASK) package

build: test
	$(CASK) build

test:
	@echo "Testing..."
	@$(CASK) $(EMACS) -Q -batch
		-L . -l csharp-mode-tests.el -f ert-run-tests-batch-and-exit

clean:
	$(CASK) clean-elc
	rm -rf dist
	rm -rf $(TESTHOME)

check-defuns:
	grep "^(defun " csharp-mode.el | sed -r "s/\(defun ([a-z0-9-]+) .*$$/\1/" | sort >/tmp/defuns.txt
	for line in `cat /tmp/defuns.txt` ; do echo -n "$$line: " ; grep "$$line" csharp-mode.el | grep -v defun | wc -l ; done >/tmp/use-count.txt
	grep " 0" /tmp/use-count.txt
