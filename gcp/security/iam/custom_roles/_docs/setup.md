## Setup
The following guide assumes commands are run from the `local` directory.

Provide the input variables with a `variables.auto.tfvars` file which can be created from the example file provided:

```bash
cp variables.auto.tfvars.example variables.auto.tfvars
```

The values set in this file should be edited according to your environment and requirements.

Once the Cloud SDK is installed you can authenticating, set the project, and choose a compute zone with the interactive command:

```bash
gcloud init
```

Ensure the required APIs are enabled:
```bash
gcloud services enable cloudresourcemanager.googleapis.com
gcloud services enable compute.googleapis.com
```

Now create a service account for Terraform to use, generate a key file for it, and save the key location as an environment variable:

```bash
gcloud iam service-accounts create terraform --display-name "Terraform, Infrastructure as Code"
gcloud projects add-iam-policy-binding [project] --member serviceAccount:terraform@[project].iam.gserviceaccount.com --role roles/compute.networkAdmin
gcloud iam service-accounts keys create terraform.json --iam-account terraform@[project].iam.gserviceaccount.com
```

**NOTE: Keep the key file in a safe place, and do not share or publicise it.**

Next export environment variable that wil be used by Terraform!

```bash
export GOOGLE_APPLICATION_CREDENTIALS="$PWD/${USER}-terraform-admin.json"
export GCP_TERRAFORM_BUCKET=tfstate-gcp-bucket
```

Next, initialise Terraform with the name of the GCS Bucket just created:

 * bucket : the name of the GCS bucket. This name must be globally unique;
 * bucket_prefix: GCS prefix inside the bucket. Named states for workspaces are stored in an object called `<prefix>/<name>.tfstate`

```bash
terraform init -backend-config=bucket=${GCP_TERRAFORM_BUCKET} -backend-config=prefix=[BUCKET_PREFIX]
```