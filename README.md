# VPC Peering Connection between two VPCs in single region using Terraform

Deploying a VPC peering connection between two VPCs in single region using Terraform

A VPC peering connection is a networking connection between two VPCs that enables you to route traffic between them using private IPv4 addresses or IPv6 addresses. Instances in either VPC can communicate with each other as if they are within the same network. You can create a VPC peering connection between your own VPCs, or with a VPC in another AWS account. The VPCs can be in different Regions (also known as an inter-Region VPC peering connection).

Architecture Diagram:

![Alt text](/images/diagram.png)

Step 1: Create two VPCs with non-overlapping cidrs.

Step 2: Host EC2 instances in each VPC

Step 3: Create a VPC peering connection with routes between two VPCs

Terraform Plan Output:
```
Plan: 17 to add, 0 to change, 0 to destroy.
```

Terraform Apply Output:
```
Apply complete! Resources: 17 added, 0 changed, 0 destroyed.

Outputs:

vpc_a_public_host_IP = "18.212.2.189"
vpc_b_public_host_IP = "3.84.14.236"
```

VPCs Created with exclusive CIDRs

![Alt text](/images/vpcs.png)

Peering connections with route tables

![Alt text](/images/peering.png)

Route Tables showing rote to peering conneciton:

![Alt text](/images/rtable1.png)

![Alt text](/images/rtable2.png)

Instances with private IP in Different CIDrs of VPCs

![Alt text](/images/instance1.png)

![Alt text](/images/instance2.png)

Connecting to EC2 in VPC-B from VPC-A

![Alt text](/images/a_to_b.png)

Connecting to EC2 in VPC-A from VPC-B

![Alt text](/images/b_to_a.png)

EC2 Instance in VPC-A

![Alt text](/images/ec2a.png)

EC2 Instance in VPC-B

![Alt text](/images/ec2b.png)

Terraform Destroy Output:
```
Plan: 0 to add, 0 to change, 17 to destroy.

Destroy complete! Resources: 17 destroyed.
```