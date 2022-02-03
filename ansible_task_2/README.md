# EPAM [Lab] DevOps Internship #24

## Ansible Basics_Practice Task 2

Напишите плейбук для создания пользователей Alice, Bob, Carol. Для каждого пользователя нужно задать имя, адрес почты в комментарии (username@example.com), домашнюю папку, пароль в зашифрованном виде – в виде зашифрованной переменной или из отдельного шифрованного файла на выбор. Кроме пароля больше ничего шифровать не нужно. У уже созданных аккаунтов пароль менять не нужно.

**ОТВЕТ:** Создадим файл `vault-pass` с паролем для шифрования. Создадим хэш пароля и зашифруем его:

```bash
$ python -c 'import crypt; print(crypt.crypt("myPassword"))'
$6$59fEJtXzyQ3cYiA/$7qdVb2WPOWqN4LMkti6abe5pk1z.7x2pILCzUHGD5RvtlFpLhi.lYw83GK.RHbd/5I5Qsai.Cgs2v0tsrphNi.

$ ansible-vault encrypt_string '$6$59fEJtXzyQ3cYiA/$7qdVb2WPOWqN4LMkti6abe5pk1z.7x2pILCzUHGD5RvtlFpLhi.lYw83GK.RHbd/5I5Qsai.Cgs2v0tsrphNi.' --vault-password-file vault-pass
!vault |
          $ANSIBLE_VAULT;1.1;AES256
          35336161623363326536343234336536386263326163396536303932363361666234386630623833
          6539353839626664343339663265613132333564343833300a326266653765373064326265353638
          66643762373864316231613239393364663763643766643331633561653033663139663862653936
          3638633030326131660a643731303237636432653532313864616435363337316561636165303166
          36666637373133346430353838663137396636663734346435353938306137663662353865303333
          35353735313631363832333066373139633836356131313831373530393337626236643338326433
          62376264306265316538623562613561313261376631396339366139643939616539343536666364
          63326136613330376164643939613961613063613938613831656430663939613162346538313862
          33623061646439373165366435383036623635653431346466333162343534333931
Encryption successful
```

Подготовим файл плейбука **[create_users.yml](./create_users.yml)**:

```yaml
---
- name: create users using a loop
  hosts: all
  become: true
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
                    35336161623363326536343234336536386263326163396536303932363361666234386630623833
                    6539353839626664343339663265613132333564343833300a326266653765373064326265353638
                    66643762373864316231613239393364663763643766643331633561653033663139663862653936
                    3638633030326131660a643731303237636432653532313864616435363337316561636165303166
                    36666637373133346430353838663137396636663734346435353938306137663662353865303333
                    35353735313631363832333066373139633836356131313831373530393337626236643338326433
                    62376264306265316538623562613561313261376631396339366139643939616539343536666364
                    63326136613330376164643939613961613063613938613831656430663939613162346538313862
                    33623061646439373165366435383036623635653431346466333162343534333931
        - name: Bob
          home: /home/Bob
          comment: Bob@example.com
          password: !vault |
                    $ANSIBLE_VAULT;1.1;AES256
                    35336161623363326536343234336536386263326163396536303932363361666234386630623833
                    6539353839626664343339663265613132333564343833300a326266653765373064326265353638
                    66643762373864316231613239393364663763643766643331633561653033663139663862653936
                    3638633030326131660a643731303237636432653532313864616435363337316561636165303166
                    36666637373133346430353838663137396636663734346435353938306137663662353865303333
                    35353735313631363832333066373139633836356131313831373530393337626236643338326433
                    62376264306265316538623562613561313261376631396339366139643939616539343536666364
                    63326136613330376164643939613961613063613938613831656430663939613162346538313862
                    33623061646439373165366435383036623635653431346466333162343534333931
        - name: Carol
          home: /home/Carol
          comment: Carol@example.com
          password: !vault |
                    $ANSIBLE_VAULT;1.1;AES256
                    35336161623363326536343234336536386263326163396536303932363361666234386630623833
                    6539353839626664343339663265613132333564343833300a326266653765373064326265353638
                    66643762373864316231613239393364663763643766643331633561653033663139663862653936
                    3638633030326131660a643731303237636432653532313864616435363337316561636165303166
                    36666637373133346430353838663137396636663734346435353938306137663662353865303333
                    35353735313631363832333066373139633836356131313831373530393337626236643338326433
                    62376264306265316538623562613561313261376631396339366139643939616539343536666364
                    63326136613330376164643939613961613063613938613831656430663939613162346538313862
                    33623061646439373165366435383036623635653431346466333162343534333931
```

Запустим плейбук на выполнение командой:

```bash
$ ansible-playbook create_users.yml --vault-password-file vault-pass

PLAY [create users using a loop] ***********************************************************************************************************************

TASK [Gathering Facts] *********************************************************************************************************************************
ok: [node1.example.com]
ok: [node2.example.com]

TASK [create users] ************************************************************************************************************************************
changed: [node1.example.com] => (item={'name': 'Alice', 'home': '/home/Alice', 'comment': 'Alice@example.com', 'password': '$6$59fEJtXzyQ3cYiA/$7qdVb2WPOWqN4LMkti6abe5pk1z.7x2pILCzUHGD5RvtlFpLhi.lYw83GK.RHbd/5I5Qsai.Cgs2v0tsrphNi.'})
changed: [node2.example.com] => (item={'name': 'Alice', 'home': '/home/Alice', 'comment': 'Alice@example.com', 'password': '$6$59fEJtXzyQ3cYiA/$7qdVb2WPOWqN4LMkti6abe5pk1z.7x2pILCzUHGD5RvtlFpLhi.lYw83GK.RHbd/5I5Qsai.Cgs2v0tsrphNi.'})
changed: [node1.example.com] => (item={'name': 'Bob', 'home': '/home/Bob', 'comment': 'Bob@example.com', 'password': '$6$59fEJtXzyQ3cYiA/$7qdVb2WPOWqN4LMkti6abe5pk1z.7x2pILCzUHGD5RvtlFpLhi.lYw83GK.RHbd/5I5Qsai.Cgs2v0tsrphNi.'})
changed: [node2.example.com] => (item={'name': 'Bob', 'home': '/home/Bob', 'comment': 'Bob@example.com', 'password': '$6$59fEJtXzyQ3cYiA/$7qdVb2WPOWqN4LMkti6abe5pk1z.7x2pILCzUHGD5RvtlFpLhi.lYw83GK.RHbd/5I5Qsai.Cgs2v0tsrphNi.'})
changed: [node1.example.com] => (item={'name': 'Carol', 'home': '/home/Carol', 'comment': 'Carol@example.com', 'password': '$6$59fEJtXzyQ3cYiA/$7qdVb2WPOWqN4LMkti6abe5pk1z.7x2pILCzUHGD5RvtlFpLhi.lYw83GK.RHbd/5I5Qsai.Cgs2v0tsrphNi.'})
changed: [node2.example.com] => (item={'name': 'Carol', 'home': '/home/Carol', 'comment': 'Carol@example.com', 'password': '$6$59fEJtXzyQ3cYiA/$7qdVb2WPOWqN4LMkti6abe5pk1z.7x2pILCzUHGD5RvtlFpLhi.lYw83GK.RHbd/5I5Qsai.Cgs2v0tsrphNi.'})

PLAY RECAP *********************************************************************************************************************************************
node1.example.com          : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
node2.example.com          : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

```
