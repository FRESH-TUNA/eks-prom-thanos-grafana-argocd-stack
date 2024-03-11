# How to bootstrap

## ec2-jumper, ssh 키 발급
```bash
# 발급된 public 키를 terraform.tfvars의 ec2-jumper-ssh-pub 키로 설정
ssh-keygen

# 키 이름을 입맛대로 변경
mv id_rsa.pub ec2-jumper.pub
mv id_rsa ec2-jumper.key
```

## 위에서 발급한 ec2-jumper, ssh private key, jumper-dmz 인스턴스로 복사
```bash
scp -i .credentials/ec2-jumper/ec2-jumper.key .credentials/ec2-jumper/ec2-jumper.key ec2-user@<your-jumper-dmz-eip>:ec2-jumper.key

scp -i ec2-jumper.key ec2-jumper.key ec2-user@52.79.93.230:ec2-jumper.key
```

## jumper-dmz, jumper-eks (private) 접속 테스트
```bash
# jumper-dmz 접속
ssh -i .credentials/ec2-jumper/ec2-jumper.key ec2-user@<your-jumper-dmz-eip>

# jumper-eks 접속
ssh -i ec2-jumper.key ec2-user@<your-jumper-eks>
```

## jumper-eks에 kubectl 설치
```
curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.28.5/2024-01-04/bin/linux/amd64/kubectl

chmod +x ./kubectl

mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$HOME/bin:$PATH

exec bash
```

## jumper-eks에서 eks 동작여부 확인
```bash
aws eks update-kubeconfig --region ap-northeast-2 --name "monitoring-practice-cluster"

kubectl get pod -A
```
