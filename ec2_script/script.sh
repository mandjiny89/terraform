#!/bin/bash
sudo yum update -y
sudo yum install lvm2 -y
sudo yum install httpd
sudo systemctl start httpd
sudo systemctl enable httpd

