# eks_localstack
localstack based eks module.

## REQUIREMENTS
You will need localstack configured with the mock keys and ready to run. As this uses EKS, you need to purchase at least the Developer version of localstac which is super cheap, and mocking aws locally rocks. Please refer to the localstack GitHub for installation, etc: [localstack](https://github.com/localstack/localstack)

You will need to have the aws-iam-authenticator tool installed in your system, and the aws cli. We use the iam authenticator to create a local kubeconfig file using the aws cli. So after you provision the cluster, install [the aws iam authenticator](https://docs.aws.amazon.com/eks/latest/userguide/install-aws-iam-authenticator.html) and aws cli. At this point, the user / role used to create the cluster is added to the system:master group in eks. So to install the aws-iam-authenticator, you can do it such as:
```bash
$ sudo curl -o /usr/bin/aws-iam-authenticator https://amazon-eks.s3.us-west-2.amazonaws.com/1.21.2/2021-07-05/bin/darwin/amd64/aws-iam-authenticator && chmod +x /usr/bin/aws-iam-authenticator
```

It is now that you can write the local kubeconfig file using for example, the aws cli:
```bash
aws eks --region region update-kubeconfig --name cluster_name
```
You'd need to change the **region** and **cluster_name** for your setup.

## PROVISIONING THE CLUSTER
To provision this cluster and add ons, remember this is done with localstack and with the special provider for aws we setup to use it (localstack). This should be transparent, so you can safely issue the next commands to have it all running in your localstack mock setup:
```bash
$ git clone https://github.com/toxeek/eks_localstack.git
$ cd eks_localstack
$ make init # this is idempotent, you can run init many times
$ make plan # not necessary on for 1st run
$ make apply
```
As you see above, we use a Makefile and its targets as a wrapper to install the eks infrastructure.

