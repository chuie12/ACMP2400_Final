## Pipeline Workflows

### terraform_start
- initializes terraform registry in azure

### build_test_scan_deploy
- runs automatically after terraform_start

### cleanup
- manually triggered to clean up terraform and azure resources
