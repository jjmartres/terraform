# Check that given variables are set and all have non-empty values,
# die with an error otherwise.
#
# Params:
#   1. Variable name(s) to test.
#   2. (optional) Error message to print.
check_defined = \
    $(strip $(foreach 1,$1, \
        $(call __check_defined,$1,$(strip $(value 2)))))
__check_defined = \
    $(if $(value $1),, \
      $(error Undefined $1$(if $2, ($2))))

.PHONY: help apply

.DEFAULT_GOAL := help

apply: ## Generate README for each Terraform modules
	@for d in $$(find . -name '.terraform-docs.yml' -exec dirname {} \;); do terraform-docs $$d; done

help: ## Show this help
	@grep -E '^([a-zA-Z_-]+|[a-zA-Z_-]+/[a-zA-Z_-]+):.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'