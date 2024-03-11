## jumper-eks에서 terraform 설치 및 프로젝트 리포 clone 해오기
```bash

# install terraform
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
sudo yum -y install terraform

# install git and clone projects
sudo yum install -y git
git clone https://github.com/FRESH-TUNA/eks-prom-thanos-grafana-argocd-stack
```