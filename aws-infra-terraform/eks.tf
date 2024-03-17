module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.8.3"

  cluster_name                   = "monitoring-practice-cluster"
  cluster_version                = 1.28
  cluster_endpoint_public_access = false

  # EKS Add-On 정의
  cluster_addons = {
    coredns = {
      most_recent       = true
      resolve_conflicts = "PRESERVE"
    }

    kube-proxy = {
      most_recent = true
    }

    vpc-cni = {
      most_recent              = true
      before_compute           = true  # 워커 노드가 프로비저닝되기 전 vpc-cni가 배포되어야한다. 배포 전 워커 노드가 프로비저닝 되면 파드 IP 할당 이슈 발생
      resolve_conflicts        = "OVERWRITE"
      service_account_role_arn = module.vpc_cni_irsa_role.iam_role_arn  # IRSA(k8s ServiceAccount에 IAM 역할을 사용한다)
      configuration_values     = jsonencode({
        env = {
          ENABLE_PREFIX_DELEGATION = "true"  # prefix assignment mode 활성화
          WARM_PREFIX_TARGET       = "1"  # 기본 권장 값
        }
      })
    }
  }

  vpc_id     = aws_vpc.monitoring-practice.id
  subnet_ids = [
    aws_subnet.private-eks-node-a.id,
    aws_subnet.private-eks-node-b.id
  ]

  # aws-auth configmap
  # manage_aws_auth_configmap = true  # AWS -> EKS 접근을위한 configmap 자동 생성

  # 관리형 노드그룹에 사용할 공통 사항 정의
  eks_managed_node_group_defaults = {
    ami_type                   = "AL2_x86_64"
    instance_types             = ["t3.large"]
    capacity_type              = "ON_DEMAND"
    iam_role_attach_cni_policy = true
    use_name_prefix            = false  # false하지 않으면 리소스 이름 뒤 임의의 난수값이 추가되어 생성됨
    use_custom_launch_template = false  # AWS EKS 관리 노드 그룹에서 제공하는 기본 템플릿을 사용
    
    block_device_mappings = {
      xvda = {
        device_name = "/dev/xvda"
        ebs = {
          volume_size           = 30
          volume_type           = "gp3"
          delete_on_termination = true
        }
      }
    }

    # Remote access cannot be specified with a launch template
    # remote_access = {  
    #   ec2_ssh_key               = module.key_pair.key_pair_name
    #   source_security_group_ids = [aws_security_group.remote_access.id]
    #   tags = {
    #     "kubernetes.io/cluster/devops-eks-cluster" = "owned"  # AWS LB Controller 사용을 위한 요구 사항
    #   }
    # }
  }

  # 관리형 노드 그룹 정의
  eks_managed_node_groups = {
    devops-eks-app-ng = {
      name         = "monitoring-practice-v2"
      labels = {
        nodegroup = "monitoring-practice-v2"
      }
      desired_size = 2
      min_size     = 2
      max_size     = 2
    }

    # 여러 노드그룹으로 나누어 구성가능!
    # devops-eks-mgmt-ng = {
    #   name         = "${local.name}-mgmt-ng"
    #   labels = {
    #     nodegroup = "mgmt"
    #   }      
    #   desired_size = 1
    #   min_size     = 1
    #   max_size     = 1
    # } 
  }

  # 레거시
  # node_security_group_additional_rules = {
  #   ingress_alb = {
  #     description                   = "sg-dmz-agw-ingress"
  #     protocol                      = "tcp"
  #     from_port                     = 0
  #     to_port                       = 65535
  #     type                          = "ingress"
  #     referenced_security_group_id = aws_security_group.sg-dmz-agw.id
  #   }
  # }

# eks service account federation with oidc
# and give iam policy to service account
enable_irsa = true

enable_cluster_creator_admin_permissions = true

  # kubectl을 통해 접근할수 있는 IAM principal 지정
  access_entries = {

    # One access entry with a policy associated
    jumper-eks = {
      # kubernetes_groups = ["master"]
      principal_arn     = aws_iam_role.jumper-eks.arn

      policy_associations = {
        jumper-eks = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = {
            # namespaces = ["default"]
            # type       = "namespace"

            type       = "cluster"
          }
        }
      }
    }
  }
}
