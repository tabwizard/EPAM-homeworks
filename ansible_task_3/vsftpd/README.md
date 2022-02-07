vsftpd
=========

This role sets up an anonymous vsftpd server and open port

Role Variables
--------------

**defaults variables for vsftpd**
```yaml
ftp_app_name: vsftpd
ftp_service: vsftpd
ftp_port: ftp
firewall_app_name: firewalld
firewall_service: firewalld
anon_path:
  - /var/ftp/pub
  - /var/ftp/pub/upload
```
  
**vars file for vsftpd**
```yaml
anon_enable: 'YES'
anon_upload_enable: 'YES'
anon_root: /var/ftp/pub
no_anon_pass: 'YES' 
```
  
Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - hosts: servers
      roles:
         - vsftpd

License
-------

MIT

Author Information
------------------

Andrei Pirozhkov
