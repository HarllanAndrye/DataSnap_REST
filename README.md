# DataSnap REST (Delphi)

Nesse projeto temos uma aplicação simples do DataSnap com REST usando os métodos GET, POST e DELETE. Também foi utilizado a autenticação com JWT.

Uso de:
* Delphi e MySQL.
* Delphi JOSE and JWT Library: [JOSE](https://github.com/paolo-rossi/delphi-jose-jwt).

O Delphi utilizado foi o tokyo 10.2.1 e para o MySQL utilizei o XAMPP (MariaDB - 10.1.26) na versão 7.1.9 para Windows.

### Banco de Dados (BD)

Você pode criar o BD assim: `CREATE DATABASE nomeDoBanco;`.

Foram criadas duas tabelas no banco de dados:

```
CREATE TABLE `users` (
  `ID` int(11) NOT NULL,
  `NAME` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `PASS` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `EMAIL` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `CPF_CNPJ` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `RG_IE` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `PHONE1` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `PHONE2` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ADDRESS` varchar(250) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `NUMBER` int(11) DEFAULT NULL,
  `NEIGHBORHOOD` varchar(250) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `CITY` varchar(250) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `STATE` varchar(150) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `COUNTRY` varchar(150) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `CEP` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

```
CREATE TABLE `wishlist` (
  `ID` int(11) NOT NULL,
  `USER_ID` int(11) NOT NULL,
  `PRODUCT_ID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```


## Como utilizar

**Método GET**

**Método POST**

**Método DELETE**


## Licença

[![CC0](https://i.creativecommons.org/l/by-nc-sa/4.0/88x31.png)](https://creativecommons.org/licenses/by-nc-sa/4.0/)

MIT License

Copyright (c) 2018 [Harllan Andryê](https://github.com/HarllanAndrye)

