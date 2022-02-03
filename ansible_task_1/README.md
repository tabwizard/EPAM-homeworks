# EPAM [Lab] DevOps Internship #24

## Ansible Basics_Practice Task 1

### Задание 1

Создайте плэйбук, выполняющий установку веб-сервера Apache на управляемом хосте со следующими требованиями:

- установка пакета httpd;
- включение службы веб-сервера и проверка, что он запущен;
- создание файла /var/www/html/index.html с текстом “Welcome to my web server”;
- используйте модуль firewalld для того, чтобы открыть необходимые для работы веб-сервера порты брендмауэра.

**ОТВЕТ:** Создадим плейбук **[httpd_enable.yml](./httpd_enable.yml)**:

```yaml
---
- name: This sets up an httpd webserver whith testfile and open port
  hosts: nodes
  become: yes
  tasks:
    - name: Install apache packages
      yum:
        name: httpd
        state: present
    - name: Creating a file /var/www/html/index.html with content
      copy:
        dest: "/var/www/html/index.html"
        content: “Welcome to my web server”
    - name: Ensure httpd is running
      service:
        name: httpd
        state: started

    - name: Install firewalld packages
      yum:
        name: firewalld
        state: present
    - name: Open port 80 for http access
      firewalld:
        service: http
        permanent: yes
        state: enabled
    - name: Restart the firewalld service to load in the firewall changes
      service:
        name: firewalld
        state: restarted
```

### Задание 2

Создайте плэйбук который:

- удалит httpd с управляемых хостов;
- удалит файл /var/www/html/index.html;
- закроет на фаерволе порты, используемые веб-сервером.

**ОТВЕТ:** Создадим плейбук **[httpd_disable.yml](./httpd_disable.yml)**:

```yaml
---
- name: Remove httpd webserver whith testfile and close port
  hosts: nodes
  become: yes
  tasks:
    - name: Remove apache packages
      yum:
        name: httpd
        state: absent
    - name: Remove file /var/www/html/index.html
      file:
        path: "/var/www/html/index.html"
        state: absent
    - name: Close port 80 for http access
      firewalld:
        service: http
        permanent: yes
        state: disabled
    - name: Restart the firewalld service to load in the firewall changes
      service:
        name: firewalld
        state: restarted
```

### Задание 3

Создайте плейбук для изменения файла /etc/default/grub. Он должен добавить параметры net.ifnames=0 и biosdevname=0 в строку, выполняющую загрузку ядра. Выполните grub2-mkconfig, чтобы записать изменения в /etc/default/grub. Используйте модуль lineinfile для изменения конфигурационного файла.

**ОТВЕТ:** Создадим плейбук **[grub.yml](./grub.yml)**:

```yaml
---
- name: Change GRUB configuration
  hosts: grub
  become: yes
  tasks:
    - name: Add GRUB net.ifnames boot parameters
      lineinfile:
        path: /etc/default/grub
        regexp: '^(GRUB_CMDLINE_LINUX=(?!.*net.ifnames)\"[^\"]*)(\".*)'
        line: '\1 net.ifnames=0\2'
        backrefs: yes

    - name: Add GRUB biosdevname boot parameters
      lineinfile:
        path: /etc/default/grub
        regexp: '^(GRUB_CMDLINE_LINUX=(?!.*biosdevname)\"[^\"]*)(\".*)'
        line: '\1 biosdevname=0\2'
        backrefs: yes

    - name: Install grub2-tools packages
      yum:
        name: grub2-tools
        state: present

    - name: Write grub configuration file
      command: grub2-mkconfig -o /boot/grub2/grub.cfg
```
