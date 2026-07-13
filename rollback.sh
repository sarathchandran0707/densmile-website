 #!/bin/bash

echo "Deployment failed!"
echo "Rolling back Kubernetes deployment..."

kubectl rollout undo deployment/densmile-deployment

echo "Rollback completed."