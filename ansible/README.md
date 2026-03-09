# Ansible

Using [Ansible](https://docs.ansible.com/projects/ansible/latest/index.html) to manage linux hosts.

## Inventory

Create the inventory file `inventory/inventory.yaml`:

```yaml
apt:
  hosts:
    apt_host1: 
      ansible_host: xx.xx.xx.xx
      ansible_user: user

dnf:
  hosts:
    dnf_host1:
      ansible_host: xx.xx.xx.xx

linux:
  children:
    apt:
    dnf:
```
