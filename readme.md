# EKS 기반 IAAS 구성

## Architecture V2
![EKS_ARCH_v2](./EKS_ARCH_v2.png)
- 고가용성 지향 (2개 가용영역 사용, EKS)
- 퍼블릭 노출 최소화
  - s3 gateway endpoint 사용
  - eks apiserver 퍼블릭 노출 차단 (jumper로만 접근)
    - kubelet과 api 서버 사이에도 endpoint를 통해 통신한다.
- 보안그룹 최소권한 원칙 적용
- eks module에서 탈피

## EKS 서비스 연구
### 대표적인 기능
- 리전단위에서 HA Control plane 제공 (여러 availability zone에 최소 2개의 API 서버, 3개의 etcd)
- EKS Cluster(일반적으로 EKS Control Plane을 의미) SLA 보장, 부하에 탄력적으로 조정
- EKS OIDC Provider를 통해 IAM Federation 및 Service Account 권한 부여 가능

### EKS에 필요한 IAM Role
- cluster IAM role
  - 컨트롤플레인측에서 사용하는 역활
- Node IAM role
  - worker node에서 필요한 역활
- Amazon VPC CNI plugin for Kubernetes IAM rule
  - EKS OIDC Provider Federation 필요
  - EKS service account가 권한을 Assume 하여 사용한다.

### SG 구조
- EKS SG
  - EKS생성시 기본으로 생성되며, worker와 master(control plane endpoint) 모두에 부착할수 있다. -> AWS측에서 트러블슈팅을 돕기위한 목적으로 추정
  - 같은 보안그룹에 한해 인바운드, 아웃바운드가 모두 허용되어있음
- Cluster SG (eks moudle 사용시 생성)
  - master(control plane endpoint)에 할당하는 보안그룹
  - Node SG (kube-proxy) 로부터의 인바운드 요청 (kube-apiserver) 허용 필요
  - Node SG (kube-proxy) 로의 아웃바운드 허용 필요
- Node SG (eks moudle 사용시 생성)
  - EKS 노드에 할당되는 보안그룹
  - Cluster SG (kube-apiserver) 로부터의 인바운드 요청 (kube-proxy) 허용 필요
  - Node SG 끼리 인바운드 전역 허용
  - Cluster SG (kube-apiserver) 로의 아웃바운드 허용 필요
- ALB SG
  - ALB SG -> Node SG 아웃바운드 허용 (리버스 프록시로 인한 아웃바운드 요청 발생)
  - internet -> ALB SG 필요한 인바운드 허용

### launch template 에 사용헌 ami 확인
```
aws ssm get-parameter --name /aws/service/eks/optimized-ami/1.28/amazon-linux-2/recommended/image_id \
                --region ap-northeast-2 --query "Parameter.Value" --output text
```

## Onboarding
### ec2-jumper, ssh 키 발급
```bash
# 발급된 public 키를 terraform.tfvars의 ec2-jumper-ssh-pub 키로 설정
ssh-keygen

# 키 이름을 입맛대로 변경
mv id_rsa.pub ec2-jumper.pub
mv id_rsa ec2-jumper.key
```
### 위에서 발급한 ec2-jumper, ssh private key, jumper-dmz 인스턴스로 복사
```bash
scp -i .credentials/ec2-jumper/ec2-jumper.key .credentials/ec2-jumper/ec2-jumper.key ec2-user@<your-jumper-dmz-eip>:ec2-jumper.key

scp -i ec2-jumper.key ec2-jumper.key ec2-user@52.79.93.230:ec2-jumper.key
```
### jumper-dmz, jumper-eks (private) 접속 테스트
```bash
# jumper-dmz 접속
ssh -i .credentials/ec2-jumper/ec2-jumper.key ec2-user@<your-jumper-dmz-eip>

# jumper-eks 접속
ssh -i ec2-jumper.key ec2-user@<your-jumper-eks>
```
### jumper-eks에 kubectl 설치
```
curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.28.5/2024-01-04/bin/linux/amd64/kubectl

chmod +x ./kubectl

mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$HOME/bin:$PATH

exec bash
```
### jumper-eks에서 eks 동작여부 확인
```bash
aws eks update-kubeconfig --region ap-northeast-2 --name "monitoring-cluster"

kubectl get pod -A
```
### jumper-eks에서 terraform 설치 및 프로젝트 리포 clone 해오기
```bash

# install terraform
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
sudo yum -y install terraform

# install git and clone projects
sudo yum install -y git
git clone https://github.com/FRESH-TUNA/eks-prom-thanos-grafana-argocd-stack
```

## S3 endpoint
```bash
## s3 endpoint 기반으로 동작하도록 구성할것
https://cloudcasanova.com/when-to-use-an-aws-s3-vpc-endpoint/

## eks의 보안그룹을 제대로 알고 쓸것

## ecr + endpoint을 써보면 좋을듯
```


