# Densmile Dental Clinic — CI/CD Pipeline (Project 4)

This repo contains the dental clinic site plus everything needed to build, test,
containerize, and automatically deploy it to AWS EC2 with rollback on failure.

```
.
├── site/index.html            ← the dental clinic website
├── Dockerfile                 ← packages the site into an nginx container
├── .github/workflows/ci-cd.yml← the pipeline itself (GitHub Actions)
└── scripts/bootstrap-ec2.sh   ← one-time EC2 setup (installs Docker)
```

## How the pipeline works

Every push to `main` runs three jobs in order:

1. **build-and-test** — builds the Docker image, boots it, and hits it with
`curl` to confirm it actually serves the site. If this fails, nothing
downstream runs.
2. **push-image** — tags the image with the Git commit SHA *and* `latest`,
then pushes both to Docker Hub. Tagging by commit SHA is what makes
rollback possible later.
3. **deploy** — SSHes into your EC2 instance, pulls the new image, stops the
old container, and starts the new one. It then runs a health check:

   * ✅ **Passes** → the new image's tag is saved as the "last stable" version.
   * ❌ **Fails** → the container is stopped and the *previous* stable image
is redeployed automatically, so the site is never left broken.

## One-time setup (do this before your first pipeline run)

### 1\. Push this repo to GitHub

```bash
git init
git add .
git commit -m "Initial commit — Densmile CI/CD pipeline"
git branch -M main
git remote add origin https://github.com/<your-username>/densmile-cicd.git
git push -u origin main
```

### 2\. Create a Docker Hub account \& access token

* Sign up at hub.docker.com (free)
* Account Settings → Security → New Access Token → copy it

### 3\. Launch an EC2 instance

* AWS Console → EC2 → Launch Instance
* Amazon Linux 2023, `t2.micro` (free tier eligible)
* Create/download a new key pair (`.pem` file) — you'll need its contents
* Security group: allow inbound **port 22** (SSH, your IP only) and **port 80** (HTTP, anywhere)
* Launch it and note its **public IPv4 address**

### 4\. Bootstrap the instance

```bash
scp -i your-key.pem scripts/bootstrap-ec2.sh ec2-user@<EC2\_PUBLIC\_IP>:\~
ssh -i your-key.pem ec2-user@<EC2\_PUBLIC\_IP>
chmod +x bootstrap-ec2.sh \&\& ./bootstrap-ec2.sh
```

### 5\. Add these secrets to your GitHub repo

`Repo → Settings → Secrets and variables → Actions → New repository secret`

|Secret name|Value|
|-|-|
|`DOCKERHUB\_USERNAME`|your Docker Hub username|
|`DOCKERHUB\_TOKEN`|the access token from step 2|
|`EC2\_HOST`|your EC2 public IP address|
|`EC2\_USER`|`ec2-user` (Amazon Linux) or `ubuntu` (Ubuntu AMI)|
|`EC2\_SSH\_KEY`|the full contents of your `.pem` file|

### 6\. Trigger the pipeline

Push any change to `main`, or go to the **Actions** tab → select the workflow
→ **Run workflow** (this is the `workflow\_dispatch` trigger — useful for
recording a clean demo run for your submission).

## Demonstrating the rollback (for your video/screenshots)

To prove the rollback actually works:

1. Let one successful deploy go through first (so a "last stable" tag exists).
2. Temporarily break the site — e.g. rename `site/index.html` so the build
step can't find it, or edit the Dockerfile to `COPY` a wrong path.
3. Push that change. The `build-and-test` job will fail before anything
reaches production — record that as your "caught before deploy" case.
4. To specifically show the **live rollback** (post-deploy failure), instead
temporarily change the health check URL in the workflow to something that
will 404, push, and watch the `deploy` job's logs show the rollback branch
executing and the previous container being restored. Revert the change
afterward.

## What to submit for Project 4

* **Code** → this repo (Dockerfile, workflow file, scripts)
* **Screenshots** → the Actions tab showing a green pipeline run; the EC2
terminal showing `docker ps` with the running container; the live site at
`http://<EC2\_PUBLIC\_IP>`
* **Video** → a screen recording of: pushing a commit → the Actions run
progressing through all three jobs → the updated site loading live →
(optional) the forced-failure rollback scenario above

## Extending beyond EC2 (optional, matches the "or Azure App Service, or

Kubernetes" line in the brief)

* **Azure App Service**: replace the `deploy` job with the
`azure/webapps-deploy` action; Azure pulls the image from Docker Hub directly.
* **Kubernetes**: replace the SSH deploy step with `kubectl set image deployment/densmile-app densmile=$IMAGE\_NAME:${{ github.sha }}`, and use
`kubectl rollout undo` for rollback instead of the manual tag-tracking
approach used here.



Updated CI/CD pipeline

