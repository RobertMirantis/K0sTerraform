# K0s - Terraform

- Install a Kubernetes cluster on AWS with K0s and Terraform (both OpenSource) on AWS.

- See my PPT for more explaination.



Step 1: Launch a new EC2 AWS instance called bootstrapperhost
    * Needs to be Ubuntu
    * You will need a keypair which you have access of (or create a new pair and save the primary key).
    * Machine can be small

Step 2: Access the the new machine
    * ssh ubuntu@<YOUR PUBLIC IP> -i <YOUR KEYPAIR.pem>

Step 3: Install software
    * TF from : https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli
    * AWS CLI : sudo apt install awscli 
    * AWS CLI configure: aws configure --> Fill in your User access key + secret key
    * K0sctl : https://github.com/k0sproject/k0sctl/releases

Step 4: Get Terraform script
    * git clone https://github.com/RobertMirantis/K0sTerraform.git
    * cd K0sTerraform

Step 5: Review variables.tf
    * Make sure the AMI-id is a valid Unbuntu AMI in your region (or use eu-central-1)
    * Make sure the key-pair name + path is correct
    * Make sure the key-pair-primary-key is in the path specified
    * Adjust number of workersnodes/masternodes (if needed).

Step 6: Run Terraform
    * terraform init
    * terraform apply (+yes)

Step 7: Enjoy a full enterprise ready Kubernetes distribution
    * Kube-config is in the main scripts directory called kube.config
    * export KUBECONFIG=<DIRECTORY>/kube.config
    * kubectl get pods --all-namespaces
    * See kubernetes from Lens:
          * Download Lens: https://k8slens.dev/
          * cat kube.config
          * Add cluster to Lens
          * Enjoy!
          Once the Cluster is running, you can shutdown the bootstraphost.

Step 10: Delete resources after playing
    * Goto bootstraphost : cd K0sTerraform directory
    * terraform destroy (+Yes)
    * Don't forget to delete the bootstraphost


The video on how I did this can be found on: https://drive.google.com/file/d/1eJOcgu81jkbgCJTwVgnEuqECVCclVDrg/view

Kind Regards,
Robert Hartevelt
PreSales Mirantis
