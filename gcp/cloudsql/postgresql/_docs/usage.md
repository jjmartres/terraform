## Usage
Basic usage of this submodule is as follows:

```hcl
module "gcp_cloudsql_instance" {
  source = "git::git@github.com:jjmartres/terraform.git//gcp/cloudsql/postgresql?ref=master"

  project = "arctic-math-252409"
  location = "europe-west1-c"
  name = "my-sql-instance"
  random_instance_name = true
  database_version = "POSTGRES_10"
  tier = "db-f1-micro"
  disk_size = 100
  maintenance_window_update_track = "stable"
  maintenance_window_day = 4
  maintenance_window_hour = 17
  ip_configuration = {
    authorized_networks = []
    ipv4_enabled        = true
    private_network     = null
    require_ssl         = true
  }
  database_flags = [
    {
      name = "max_connections"
      value = 100
    }]
  user_labels = {
    "plop": "test",
    "type": "main"
  }
  backup_configuration = {
    enabled = true
    start_time = "05:00"
    location = null
    point_in_time_recovery_enabled = false
  }
  db_name = "test-db-001"
  db_charset = "UTF8"
  db_collation = "en_US.UTF8"
  additional_databases = [
    {
      name = "test-db-002",
      charset = "UTF8"
      collation = "en_US.UTF8"
    },
    {
      name = "test-db-003",
      charset = "UTF8",
      collation = "en_US.UTF8"
    }]
  user_name = "whoooo"
  user_password = "ooooohw"
  deletion_protection = false
  read_replica_name_suffix = "-"
  read_replicas = [
    {
      name = "01",
      tier = "db-f1-micro",
      location = "europe-west1-c",
      disk_type = "PD_HDD",
      disk_autoresize = true,
      disk_size = "100",
      user_labels = {
        "plop": "test",
        "type": "replica"
      },
      database_flags = [
        {
          name = "max_connections"
          value = 100
        }]
      ip_configuration = {
        authorized_networks = [],
        ipv4_enabled        = true,
        private_network     = null,
        require_ssl         = true
      }
    }]
}
```
### Applying

Now that Terraform is setup check that the configuration is valid:

```bash
terraform validate 
```

To get a complete list of the different resources Terraform will create to achieve the state described in the configuration files you just wrote, run :

```bash
terraform plan
```

If the configuration is valid then apply it with:

```bash
terraform apply [-auto-approve]
```

Inspect the output of apply to ensure that what Terraform is going to do what you want, if so then enter `yes` at the prompt.
The infrastructure will then be created, this make take a some time.


### Clean Up

Remove the infrastructure created by Terraform with:

```bash
terraform destroy [-auto-approve]
rm -rf .terraform
```

Sometimes Terraform may report a failure to destroy some resources due to dependencies and timing contention.
In this case wait a few seconds and run the above command again. If it is still unable to remove everything it may be necessary to remove resources manually using the `gcloud` command or the Cloud Console.

The GCS Bucket used for Terraform state storage can be removed with:

```bash
gsutil rm -r gs://[BUCKET]
```