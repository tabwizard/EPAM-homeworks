# EPAM-homeworks for [Lab] DevOps Internship #24

## Ansible Basics_Practice Task 2

Напишите плейбук для создания пользователей Alice, Bob, Carol. Для каждого пользователя нужно задать имя, адрес почты в комментарии (username@example.com), домашнюю папку, пароль в зашифрованном виде – в виде зашифрованной переменной или из отдельного шифрованного файла на выбор. Кроме пароля больше ничего шифровать не нужно. У уже созданных аккаунтов пароль менять не нужно.

**ОТВЕТ:** Создадим файл `vault-pass` с паролем для шифрования. Подготовим зашифрованный пароль пользователя:

```bash
ansible-vault encrypt_string --vault-password-file vault-pass 'my_password' --name 'password'
password: !vault |
          $ANSIBLE_VAULT;1.1;AES256
          39313031303666313035613665653565323463633031626566656437643531346630303462373839
          3466316463383236363262343261343065313966366335340a303633373932396666653539393230
          34363235623435306163613137396430363066396561643661666133323764323262376162316132
          6631383138363665340a333938303134653233326637303531663066356336653333613231373233
          3063
Encryption successful
```

Подготовим файл плейбука **[create_users.yml](./create_users.yml)**:

```yaml
---
- name: create users using a loop
  hosts: all
  tasks:
    - name: create users
      user:
        state: present
        name: "{{ item.name }}"
        home: "{{ item.home }}"
        comment: "{{ item.comment }}"
        password: "{{ item.password }}"
        update_password: on_create
      loop:
        - name: Alice
          home: /home/Alice
          comment: Alice@example.com
          password: !vault |
            $ANSIBLE_VAULT;1.1;AES256
            39313031303666313035613665653565323463633031626566656437643531346630303462373839
            3466316463383236363262343261343065313966366335340a303633373932396666653539393230
            34363235623435306163613137396430363066396561643661666133323764323262376162316132
            6631383138363665340a333938303134653233326637303531663066356336653333613231373233
            3063
        - name: vova
          groups: users
        - name: max
          groups: users
```

Запустим плейбук на выполнение командой:

```bash
ansible-playbook create_user.yml --vault-password-file vault-pass
```