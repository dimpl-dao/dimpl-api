aws s3api put-object --bucket dimpl-keys --key backend/.env --body ./config/.env.production
aws s3api put-object --bucket dimpl-keys --key backend/private_key.pem --body ./config/keys/private_key.pem 