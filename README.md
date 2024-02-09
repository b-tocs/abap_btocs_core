# B-Tocs ABAP SDK
![Bride To Other Cool Stuff](res/btocs_logo.gif)

## Summary 

Welcome to the B-Tocs ABAP SDK. With this ABAP extension your SAP ABAP Server can connect to other cool stuff.

This ABAP package is a free to use at your own risk.  You can install it via [abapGit](https://www.abapgit.org).

See the [Youtube Channel](https://youtube.com/channel/UCk4K1ZKPW4sdngJPcYeHJCA) for videos regarding this ABAP addon and the available Plugins.

## Features

```mermaid
mindmap
  root((ABAP SDK))
    Utils
      Logger
      User Context
      JSON Support
      Conversions
      Config Manager   
      Text Util   
    Remote Web Services
        WebService Client
        WebService Connector
    Security
        Secrets
        Authentification Methods
        JWT Tokens
```

## Architecture

```mermaid
flowchart LR
    subgraph sap["SAP ABAP System"]
        sap_bf["SAP Business Functions"]
        subgraph sdk["B-Tocs SDK"]
            plugin1
            plugin2
            plugin3
            plugin4
            plugin5
            sdkcore
            sdkcore-->plugin1
            sdkcore-->plugin2
            sdkcore-->plugin3
            sdkcore-->plugin4
            sdkcore-->plugin5
        end
        sap_bf-->sdkcore
    end

    subgraph cloud-native-world["Cloud Native World"]
        subgraph onpremise["Data Center On-Prem"]
            coolstuff1
        end
        subgraph datacenter["Data Center"]
            coolstuff2
        end
        subgraph hyperscaler["HyperScaler"]
            coolstuff3
        end
        subgraph sapbtp["SAP BTP"]
            coolstuff4
        end
        subgraph saas["SaaS"]
            coolstuff5
        end
    end

    plugin1 --> coolstuff1    
    plugin2 --> coolstuff2    
    plugin3 --> coolstuff3    
    plugin4 --> coolstuff4    
    plugin5 --> coolstuff5    

```

## Known plugins

| Plugin                | Solution                                              | Category              | Repository                                                |
| ---                   | ---                                                   | ---                   | ---                                                       |
| DEEPL                 | [DeepL](https://deepl.com/)                           | Translation           | https://github.com/b-tocs/abap_btocs_deepl                |
| LIBTRL                | [LibreTranslate](https://libretranslate.com/)         | Translation           | https://github.com/b-tocs/abap_btocs_libtrl               |
| OLLAMA                | [Ollama](https://ollama.ai/)                          | LLM, Chatbot, GPT     | https://github.com/b-tocs/abap_btocs_ollama               |

Planned:
- Stirling PDF


## Prerequisites and Installation 

- SAP ABAP from 7.50 releases until current S/4 HANA on premise 
- Package name:
    - ZBTOCS_CORE - if your system will be upgraded in the future 
    - otherwise $ZBTOCS_CORE or $BTOCS_CORE without transport requests


## Demos

| SAP object                    | Description                           |
| ----------------------------- | ------------------------------------- |
| PROG ZBTOCS_GUI_DEMO_RWS_CALL | B-Tocs Demo - Call Remote Web Service |



## Known Issues
- SSL - SAP Basis issue depending on remote certificates in older systems
