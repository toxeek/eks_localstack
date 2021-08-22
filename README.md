# eks_localstack
localstack based eks module, few things taken from others such as Shirwa's eks crafter cms module. - I USE TERRAFORM WORKSPACES (tbc) -

## REQUIREMENTS
You will need localstack configured with the mock keys and ready to run. As this uses EKS, **YOU WILL NEED TO PURCHASE AT LEAST THE DEVELOPER VERSION OF LOCALSTACK**, which is super cheap, and mocking aws locally rocks. Please refer to the localstack GitHub for installation, etc: [localstack](https://github.com/localstack/localstack)

You will need to have the aws-iam-authenticator tool installed in your system, the aws cli, and also Helmv3.4.0 at least. We will use tfenv to install and manage the Terraform version/s, so tfenv should be installed. The required IAM setup will be done with the code. We use the iam authenticator to create a local kubeconfig file using the aws cli. So after you provision the cluster, install [the aws iam authenticator](https://docs.aws.amazon.com/eks/latest/userguide/install-aws-iam-authenticator.html) and aws cli. At this point, the user / role used to create the cluster is added to the system:master group in eks. So to install the aws-iam-authenticator, you can do it such as:
```bash
$ sudo curl -o /usr/bin/aws-iam-authenticator https://amazon-eks.s3.us-west-2.amazonaws.com/1.21.2/2021-07-05/bin/darwin/amd64/aws-iam-authenticator && chmod +x /usr/bin/aws-iam-authenticator
```

It is now that you can write the local kubeconfig file using for example, the aws cli:
```bash
aws eks --region region update-kubeconfig --name cluster_name
```
You'd need to change the **region** and **cluster_name** for your setup.

In order to install Helm3, follow the notes on its website is really simple.

## PROVISIONING THE CLUSTER
FIRST OF ALL, you need to make sure you initialise the workspace, as wqe use terraform workspaces for the different environments, e.g.:
```bash
$ terraform workspace select development || terraform workspace new development
$ terraform workspace select development
```

To provision this cluster and add ons, remember this is done with localstack and with the special provider for aws we setup to use it (localstack). This should be transparent, so you can safely issue the next commands to have it all running in your localstack mock setup:
```bash
$ git clone https://github.com/tfutils/tfenv.git ${HOME}/.tfenv &>/dev/null || exit 125
$ ln -s ${HOME}/.tfenv/bin/* /usr/local/bin 2>/dev/null
$ tfenv install 0.13.7
$ git clone https://github.com/toxeek/eks_localstack.git
$ cd eks_localstack
$ make init # this is idempotent, you can run init many times
$ make update # not necessary on for 1st run
$ make plan
$ make apply
```
As you see above, we use a Makefile and its targets as a wrapper to install the eks infrastructure. The available targets of the Makefile are:
1. **init**: initialises the tf code
2. **update**: updates the modules used
3. **plan**: does a terraform plan outputing to a local .tfstate file
4. **apply**: applies the tf code in the .tfstate file created by the plan target
5. **clean**: cleans up the local tf setup (.terraform and .tfstate file)
6. **destroy**: does a terraform destroy of the eks setup

In this case, we create our own vpc, but you can use the terraform remote state, and use an existing vpc (you'll need to change the code). You use remote states whenever you want to run code in existing infrastructure so make as many changes as you like.

## ADD ONS
All add-ons should be installed after we have run Terraform.
**For External DNS**: make sure you have a role named ExternalDnsIAMRole in your aws account. You can find the policies needed for the role online.
We use helm and the Terraform helm-release resource type to install different charts. Also make sure you change the script under the add-ons folder, the lines that refer to:
  --set aws.zoneType=public \
  --set txtOwnerId=external-dns \
  --set domainFilters[0]=toxeeklabs.com \
...
Use your own setup there.