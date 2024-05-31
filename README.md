# Sumo Logic CSE Terraform Repository

This repository contains Terraform configurations for managing Sumo Logic Cloud SIEM Enterprise (CSE) resources, including aggregation rules, chain rules, first seen rules, match rules, outlier rules, threshold rules, rule tuning expressions, and tag schemas. This readme assumes the reader has basic knowledge of how to configure Sumo CSE. This is not a guide on how to write configurations.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Setup](#setup)
- [Usage](#usage)
- [Examples](#examples)
- [Contributing](#contributing)
- [License](#license)

## Prerequisites

Before you begin, ensure you have the following:

- [Terraform](https://www.terraform.io/downloads.html) installed on your local machine.
- A Sumo Logic account with appropriate permissions to manage CSE resources.
- Sumo Logic API credentials (Access ID and Access Key).

## Setup

1. **Clone the repository:**

    ```sh
    git clone https://github.com/your-username/sumologic-cse-terraform.git
    cd sumologic-cse-terraform
    ```

2. **Configure your Sumo Logic credentials using environment variables:**

    Export your Sumo Logic API credentials as environment variables:

    ```sh
    export SUMOLOGIC_ACCESS_ID="your-access-id"
    export SUMOLOGIC_ACCESS_KEY="your-access-key"
    export SUMOLOGIC_ENVIRONMENT="us1"  # Change this to your Sumo Logic environment
    ```

3. **Create a Terraform variables file:**

    Create a file named `terraform.tfvars` and add the following content:

    ```hcl
    sumologic_access_id     = var.sumologic_access_id
    sumologic_access_key    = var.sumologic_access_key
    sumologic_environment   = var.sumologic_environment
    ```

4. **Initialize Terraform:**

    ```sh
    terraform init
    ```

## Usage

To create a plan for the configurations, run:

```sh
terraform plan
```

To apply the configurations, run:

```sh
terraform apply
```

You will be prompted to confirm the changes before they are applied.

## Examples

There are two ways to deploy this repository, YAML based and resource based.

### YAML Based

https://github.com/causticcutlery/sumo-cse-terraform/tree/main/method_yaml_based

This is my preferred way to deploy Terraform. It involves writing the Terraform resources in an agnostic way that reads a YAML config file, which contains all the desired configurations. It is more objected oriented and is easier to maintain. The biggest benefit here is that someone can add configurations without having to know much about Terraform or HCL.

### Resource Based 

https://github.com/causticcutlery/sumo-cse-terraform/tree/main/method_resource_based/

Another way of deploying Terraform resources, but I think it is more difficult to maintain. There are no YAML configuration files, but instead you write a separate resource for each configuration you want to deploy.

## Contributing

Contributions are welcome! If you find any issues or have suggestions for improvements, feel free to open an issue or create a pull request.

## License

This repository is licensed under the [Apache License](https://github.com/causticcutlery/sumo-cse-terraform/blob/main/LICENSE).