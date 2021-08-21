# eks_localstack
localstack based eks module.

## REQUIREMENTS
You will need localstack configured with the mock keys and ready to run. As this uses EKS, you need to purchase at least the Developer version of localstac which is super cheap, and mocking aws locally rocks. Please refer to the localstack GitHub for installation, etc: [localstack](https://github.com/localstack/localstack)

You will need to have the aws-iam-authenticator tool installed in your system, and the aws cli. We use the iam authenticator to create a local kubeconfig file using the aws cli. So after you provision the cluster, install [the aws iam authenticator](https://docs.aws.amazon.com/eks/latest/userguide/install-aws-iam-authenticator.html) and aws cli. At this point, the user / role used to create the cluster is added to the system:master group in eks. So to install the aws-iam-authenticator, you can do it such as:
```bash
$ sudo curl -o /usr/bin/aws-iam-authenticator https://amazon-eks.s3.us-west-2.amazonaws.com/1.21.2/2021-07-05/bin/darwin/amd64/aws-iam-authenticator && chmod +x /usr/bin/aws-iam-authenticator
```

