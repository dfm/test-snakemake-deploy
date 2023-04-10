## Install dependencies

Google Cloud SDK:

```bash
brew install --cask google-cloud-sdk
```

Snakemake:

```bash
mamba create -n test-snakemake-deploy python=3.10 bioconda::snakemake kubernetes
mamba activate test-snakemake-deploy
python -m pip install kubernetes
```

## Setup Google Cloud

First, create a Google Cloud Project and enable Compute Engine.
Then, create a Google Storage Bucket (we'll call it `dfm-test-bucket` for now).
I also had to run:

```bash
gcloud init
gcloud services enable container.googleapis.com
gcloud components install gke-gcloud-auth-plugin
```

Then authenticate with:

```bash
gcloud auth application-default login
```

And create a cluster:

```bash
export CLUSTER_NAME="test-cluster"
gcloud container clusters create $CLUSTER_NAME \
    --num-nodes=1 \
    --machine-type="n1-standard-8" \
    --scopes storage-rw \
    --disk-size=500GB \
    --enable-autoscaling \
    --max-nodes=2 \
    --min-nodes=0
gcloud container clusters get-credentials $CLUSTER_NAME
```

And run snakemake:

```bash
snakemake --kubernetes --use-conda --cores 1 --jobs 2 \
    --default-remote-provider GS \
    --default-remote-prefix dfm-test-bucket \
    --default-resources "machine_type=n1-standard-8"
```

## Don't forget

```bash
gcloud container clusters delete $CLUSTER_NAME
```

