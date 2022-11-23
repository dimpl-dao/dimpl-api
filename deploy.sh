docker build -t dimpl-api . &&
docker tag dimpl-api 880835873002.dkr.ecr.ap-northeast-2.amazonaws.com/dimpl-api:latest &&
aws ecr get-login-password --region ap-northeast-2 | docker login --username AWS --password-stdin 880835873002.dkr.ecr.ap-northeast-2.amazonaws.com/dimpl-api &&
docker push 880835873002.dkr.ecr.ap-northeast-2.amazonaws.com/dimpl-api