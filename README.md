# B-Tocs ABAP SDK

## Summary 

Welcome to the B-Tocs ABAP SDK. With this ABAP extension your SAP ABAP Server can connect to other cool stuff.

![Bride To Other Cool Stuff](res/btocs_logo_800x340_transparent.gif)

This ABAP package is an free to use ABAP at your own risk.  You can install it via [abapGit](https://www.abapgit.org).
See the [Youtube Channel](https://youtube.com/channel/UCk4K1ZKPW4sdngJPcYeHJCA) for videos regarding this ABAP addon and the available Plugins.

## Architecture

```mermaid
flowchart LR
    subgraph sap["SAP ABAP System"]
    
        subgraph sdk["B-Tocs SDK"]
            plugin1
            plugin2
            plugin3
            plugin4
            plugin5
        end
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
- [LibreTranslate](https://github.com/b-tocs/abap_btocs_libtrl) - Translation


## Prerequisites

SAP ABAP from 7.40 until current S/4 HANA on premise releases (e.g. 7.5x)

## Known Issues

- 





last modified: 17.01.2024
