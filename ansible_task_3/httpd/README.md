Role Name
=========

This role sets up an httpd webserver whith testfile and open port


Role Variables
--------------

**defaults file for httpd**
```yaml
http_app_name: httpd
http_service: httpd
http_port: http
firewall_app_name: firewalld
firewall_service: firewalld
```
**vars file for httpd**
```yaml
var1: "some variable from vars"
```

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - hosts: servers
      roles:
         - httpd

License
-------

MIT

Author Information
------------------

Andrei Pirozhkov
