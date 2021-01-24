# How to launch (restart the console for reruns)

Open cloud shell (top right corner) and execute this commands

```bash
sudo -s
cd ~
git clone https://github.com/asborsiov/gcp-terraform-ansible-pipe.git /opt/bootstrap
bash /opt/bootstrap/install.sh
```
# How to ssh manually 
copy remote_user from /opt/bootstrap/ansible.cfg<br>
copy key file /opt/bootstrap/ssh-key<br>
```bash
ssh -i <ssh-key> <remote_user>@<vm-public_ip>
```
# How ansible pipeline works
Script generates following files from created VMs and generated keys:<br>
```bash
/opt/bootstrap/ansible/ansible.cfg 
/opt/bootstrap/hosts 
/opt/bootstrap/ssh-key
```
Where 'ansible.cfg' file has ssh username, 'hosts' has public IP associations of created VMs and 'ssh-key' is a private key used to ssh into those VMs.<br>
<br>
Copy them into your local machine, go into the folder where ansible.cfg reside and launch with this command:<br>
```bash
ansible-playbook -i /opt/bootstrap/hosts /opt/bootstrap/ansible/postgres-kafka-nifi.yaml --private-key /opt/bootstrap/ssh-key
```
