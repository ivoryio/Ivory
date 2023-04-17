# Solaris Demo Application

A proof-of-concept mobile-banking application that uses a [Solaris](https://docs.solarisgroup.com/api-reference/)_-like_ BE API.

## General architecture overview

The Mobile bank application is built with Flutter and can be deployed on both iOS and Android devices.

The Mobile application connects to a backend layer that connects to a [mock-solaris](https://github.com/kontist/mock-solaris).instance. AWS Cognito is used on the backend middle layer to authenticate and differentiate users.

```mermaid
graph LR
    subgraph BFF[Backend Layer]
      COG[AWS Cognito]
    end

    MBA[Mobile Banking App] --> |uses|BFF
    BFF --> |uses|MS[Mocked Solaris API]
```

Environment variables can be set by copying `.env.example` to `.env` _(in root folder)_ and adding the values to the varibles.

## Scope

The application already includes the following features:
- Email + password login
- User dashboard / landing page
- Transactions list
- Send money to a person

| <img src="https://user-images.githubusercontent.com/16261042/232440439-f297a8e0-9e81-40af-b62a-1395da311c4b.jpg" width="150" /> 
| <img src="https://user-images.githubusercontent.com/16261042/232440449-8b31d943-2112-495d-b478-2c11c2576638.jpg" width="150" /> 
| <img src="https://user-images.githubusercontent.com/16261042/232440452-341be72a-9e10-4c22-8176-ebc1e5842145.jpg" width="150" /> 
| <img src="https://user-images.githubusercontent.com/16261042/232440454-f47425ec-49fe-431a-94fe-937d1d5c55cd.jpg" width="150" /> 
| <img src="https://user-images.githubusercontent.com/16261042/232441790-9763ba80-9af6-410b-a62b-34babc2c6ac8.jpg" width="150" /> |

The following features are planned to be implemented:
1. Physical card details
1. Filter & sort transactions
1. Account details
1. Top up
1. Transaction details
1. Search through transactions
1. Physical card - deactivate
1. Physical card - set card PIN
1. Physical card - Freeze / Unfreeze
1. Send money to a saved payee
1. Sign UP


## Contact

For any questions, guidance or other interests _(like building projects or getting hired)_ contact [Thinslices](https://www.thinslices.com/contact).
