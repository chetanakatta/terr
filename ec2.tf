
resource "aws_instance" "expense" {

    ami = "ami-09c813fb71547fc4f"
    vpc_security_group_ids = ["sg-035be4e538db0b944"] 
    instance_type = "t3.micro"
    #after creating instance save ip address into a file in local
    #provisioners will run when creating instaces; they will not run once the resource is created
    provisioner "local-exec" {
        command = "echo ${self.private_ip} > private_ips.txt"  #self is aws_instace.web
    }
    #provisioner "local-exec" {
    #    command = "ansible-playbook -i private_ips.txt web.yaml"
    #}
    #remote-exec--> first we need to connect to the server to run inside remote server
    connection {
        type = "ssh"
        user = "ec2-user"
        password = "DevOps321"
        host = self.public_ip
    }
    provisioner "remote-exec" {
        inline = [
            "sudo dnf install ansible -y",
            "sudo dnf install nginx -y",
            "sudo systemctl start nginx"

        ]
    }
}
