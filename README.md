<h3 align="center">
    <img alt="Logo" title="#logo" width="150px" src="https://github.com/julionery/lubiju-admin-flutter-firebase/blob/master/assets/icon/icon.png?raw=true">
</h3>
<h1 align="center">Aplicativo Administrativo Lú Biju</h1>

### Aplicativo desenvolvido em Flutter e Firebase contendo a administração do app [Lú Biju](https://github.com/julionery/lubiju-flutter-firebase).

### :bookmark_tabs: Funcionalidades: 
 - Sistema de Login com E-mail e Senha
 - Cadastro das categorias, produtos, novidades, cupons e lojas
 - Acompanhamento dos usuários, pedidos e mensagens
 - Atualização dos status dos pedidos
 
### :rocket: Tecnologias:
- [Flutter](https://flutter.dev/ "Flutter")
- [Firebase](https://firebase.google.com/ "Firebase")

### :globe_with_meridians: Autenticação :
- [Firebase Authentication](https://firebase.google.com/products/auth?hl=pt-br&gclid=Cj0KCQjwoPL2BRDxARIsAEMm9y8XhSHtYRrjL7OPk8hVPM_Qr0_xGwuc7-vYYIZ-VBIAQtphlU3LQlcaAoEAEALw_wcB)

### :computer: Bibliotecas e ferramentas:
- [Bloc Patern](http://flutterdevs.com/blog/bloc-pattern-in-flutter-part-1/)
- [Shimmer](https://github.com/hnvn/flutter_shimmer)
- [Image Picker](https://github.com/flutter/plugins/tree/master/packages/image_picker/image_picker)
- Google SignIn
- Firebase Storage

<h2 align="center">Demonstração</h2>

<h3 align="center">
    <img width="250px" src="https://github.com/julionery/docs/blob/master/LuBiju/lubiju-admin-login.gif?raw=true">&nbsp;&nbsp;  
    <img width="250px" src="https://github.com/julionery/docs/blob/master/LuBiju/lubiju-admin-orders.gif?raw=true">&nbsp;&nbsp;
    <img width="250px" src="https://github.com/julionery/docs/blob/master/LuBiju/lubiju-admin-news.gif?raw=true">
</h3>

<h3 align="center">
    <img width="250px" src="https://github.com/julionery/docs/blob/master/LuBiju/lubiju-admin-products.gif?raw=true">&nbsp;&nbsp;  
    <img width="250px" src="https://github.com/julionery/docs/blob/master/LuBiju/lubiju-admin-cupon-sotres-mesages.gif?raw=true">
</h3>

### :information_source: Como Usar:

Para executar corretamente esta aplicação você precisará:
 - [Git](https://git-scm.com) e [NodeJS](https://nodejs.org/en/) já instalados;
 - [Ambiente flutter](https://flutter.dev/docs/get-started/install) já configurado;
 - [Criar um projeto Firebase](https://firebase.google.com/docs/projects/learn-more) e [configura-lo ao Flutter](https://firebase.google.com/docs/flutter/setup).

No seu terminal digite os comandos:

```bash
# Clone este repositório
$ git clone https://github.com/julionery/lubiju-admin-flutter-firebase.git

# Entre na pasta do repositório
$ cd lubiju-admin-flutter-firebase

# Execute o comando para baixar os pacotes
$ flutter pub get

# Execute a aplicação no seu emulador ou dispositivo.

```


### :globe_with_meridians: Admin Authentication

Para acessar esta aplicação você precisa:

1. Habilitar a autenticação por email
![Screenshot_2](https://user-images.githubusercontent.com/15279868/93206022-1d944000-f72f-11ea-8480-a094936615c7.jpg)

2. Adicionar um novo usuário e copiar o UID
![Screenshot_5](https://user-images.githubusercontent.com/15279868/93206074-33096a00-f72f-11ea-9c20-6a991e137d3a.jpg)
![Screenshot_1](https://user-images.githubusercontent.com/15279868/93206109-46b4d080-f72f-11ea-92b6-0af882293067.jpg)

3. Criar uma nova coleção com o nome "admins" e criar um novo documento com o Document ID e um campo com o name "uid" com o UID dos usuário que irá ser administrador
![Screenshot_4](https://user-images.githubusercontent.com/15279868/93206133-52a09280-f72f-11ea-9fe6-e716f78f84fe.jpg)
![Screenshot_3](https://user-images.githubusercontent.com/15279868/93206146-56341980-f72f-11ea-9dd3-8f6bfb16291c.jpg)

## :link: Como contribuir

- Faça um **fork** do projeto;
- Crie uma nova branch com as suas alterações: `git checkout -b my-feature`
- Salve as alterações e crie uma mensagem de commit contando o que você fez:`git commit -m "feature: My new feature"`
- Envie as suas alterações: `git push origin my-feature`

> Caso tenha alguma dúvida confira este [guia de como contribuir no GitHub](https://github.com/firstcontributions/first-contributions).

## :memo: Licença
Esse projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.

---

<h4 align="center">
    Feito com ❤ por <a href="https://www.linkedin.com/in/julio-nery/" target="_blank">Júlio Nery</a>!
    <g-emoji class="g-emoji" alias="wave" fallback-src="https://github.githubassets.com/images/icons/emoji/unicode/1f44b.png">👋</g-emoji>
</h4>
