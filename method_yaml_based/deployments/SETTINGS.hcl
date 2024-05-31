locals {
    terraform_required_providers = {
        sumologic = {
            source = "SumoLogic/sumologic"
            version = "~> 2"
        }
    }

    providers = {
        sumologic = {
            environment = "{env code}" #e.g., us1, us2, eu, au, jp, in, de, ca, fed
        }
    }
}
