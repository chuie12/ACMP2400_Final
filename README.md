## Pipeline Workflows

### terraform_start
- initializes terraform registry in azure

### build_test_scan_deploy
- runs automatically after terraform_start
- if it fails, run cleanup before starting again

### cleanup
- manually triggered to clean up terraform and azure resources
