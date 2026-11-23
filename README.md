# 🖥️ Lab Infrastructure Digitale — Windows Server & Réseaux


Je suis **Hiba Khaddi**, étudiante en 2ᵉ année de **Technicien Spécialisé en Infrastructure Digitale** à l'OFPPT (ISTA), Casablanca.


Ce dépôt présente **mes travaux pratiques** d'administration systèmes et réseaux : chaque TP est réalisé sur mon propre laboratoire, documenté pas à pas (objectif, étapes, vérifications, pièges rencontrés) et accompagné de ses scripts quand il y en a. C'est le journal vivant de ma progression vers le stage PFE et la certification CCNA.


**Environnement de lab** : Windows Server 2019 (**SVR1**) — domaine Active Directory **isfo.com** — AD DS, DNS, DHCP et stratégies de groupe (GPO).


---


## 🧪 Mes travaux pratiques


| N° | Travaux pratiques | Objectif | Statut |
|---|---|---|---|
| 1 | [Magasin central des modèles d'administration (ADMX/ADML)](travaux-pratiques/TP-Magasin-Central-ADMX.md) | Centraliser les définitions de stratégie de groupe dans SYSVOL pour que tous les contrôleurs de domaine utilisent les mêmes modèles | ✅ Terminé — 23/10/2026 |
| 2 | [Création et liaison de GPO en PowerShell](scripts-powershell/Creer-Lier-GPO.ps1) | Créer une GPO et la lier à des OU avec `New-GPLink` (paramètres nommés obligatoires) | ✅ Terminé |
| 3 | [Rapport d'héritage des GPO](scripts-powershell/Rapport-Heritage-GPO.ps1) | Diagnostiquer l'héritage d'une OU (`Get-GPInheritance`) et générer un rapport `gpresult` en HTML | ✅ Terminé |
| 4 | [Routage dynamique RIPv2 + DHCPv4, et IPv6 (DHCPv6 + RIPng)](travaux-pratiques/TP-Routage-RIPv2-DHCPv4.md) | Configurer le routage dynamique RIPv2 et RIPng et les serveurs DHCPv4 et DHCPv6 entre deux LAN | ✅ Terminé | 
| 5 | [Windows Admin Center + Server Core](travaux-pratiques/TP-Windows-Admin-Center-Server-Core.md) | Administrer à distance un serveur Windows Server 2019 Core (sans interface graphique) depuis un navigateur avec Windows Admin Center | ✅ Terminé |
| 6 | [TP ajout d'une machine au domaine isfo.com (pc-hiba)](travaux-pratiques/TP-Ajout-Machine-Domaine-isfo.md) | Ajouter la machine pc-hiba au domaine Active Directory isfo.com | ✅ Terminé |
| 7 | [TP configuration du basculement (failover) d'une étendue DHCP](travaux-pratiques/TP-Basculement-Etendues-DHCP.md) | Configurer le basculement (failover) d'une étendue DHCP | ✅ Terminé |
| 8 | [Énumération basée sur l'accès (EBA) sur un partage Windows Server](travaux-pratiques/TP-Enumeration-Basee-Acces-EBA.md) | Masquer les dossiers d'un partage aux utilisateurs qui n'y ont pas accès (partage Partage_EBA sur SVR1, dossiers Commun/Hiba/Wiam) | ✅ Terminé — 28/10/2026 |
| 9 | [Quota FSRM sur le partage Partage_EBA](travaux-pratiques/TP-Quota-FSRM-Partage-EBA.md) | Limiter l'espace du partage (quota inconditionnel, seuil d'alerte à 85 %, modèle « mon quota ») et vérifier le blocage en test réel | ✅ Terminé — 28/10/2026 |
| 10 | [Filtrage de fichiers FSRM: bloquer les images](travaux-pratiques/TP-Filtrage-Fichiers-FSRM.md) | Empêcher le dépôt de fichiers image dans le partage (filtrage actif, modèle « Bloquer les fichiers image ») | ✅ Terminé — 28/10/2026 |
| 11 | [Déduplication des données sur le volume H:](travaux-pratiques/TP-Deduplication-Donnees.md) | Installer la déduplication en PowerShell, l'activer sur le volume H: et lancer un travail d'optimisation | ✅ Terminé |
| 12 | [Haute disponibilité des services : 2e contrôleur de domaine, espace de noms DFS et réplication DFSR](travaux-pratiques/TP-Haute-Disponibilite-DC2-DFS.md) | Promouvoir un 2e contrôleur de domaine, créer un espace de noms DFS et répliquer le partage avec DFSR | ✅ Terminé |
| 13 | [Infrastructure multi-sites IPv6 — EtherChannel, VLAN, RIPng, DHCPv6 Stateful](travaux-pratiques/TP-Infrastructure-IPv6-RIPng-DHCPv6.md) | Mettre en place une infrastructure IPv6 multi-sites (CASA / SETTAT) : EtherChannel, VLAN, routage inter-VLAN, RIPng et DHCPv6 Stateful | ✅ Terminé |
| 14 | [ACL standard numérotées et nommées (Packet Tracer)](travaux-pratiques/TP-ACL-Standard.md) | Filtrer le trafic entre 3 LAN avec des ACL standard : bloquer un réseau entier, isoler un LAN, puis bloquer une seule machine avec une ACL nommée | ✅ Terminé — 19/11/2026 |
| 15 | [Gestion des disques sous Fedora (fdisk, parted, fstab)](travaux-pratiques/TP-Gestion-Disques-Fedora.md) | Partitionner, formater (NTFS et ext4) et monter des disques sous Linux, avec montage permanent via /etc/fstab | ✅ Terminé — 17/11/2026 |
| 16 | [Supervision du lab isfo.com avec Zabbix et auto-réparation](travaux-pratiques/TP-Supervision-Zabbix.md) | Installer un serveur Zabbix 7.0 sur Ubuntu Server, superviser SVR1 et SVR_2 (agents, services AD DS/DNS/DHCP/DFS), créer le tableau de bord « Parc isfo.com » et une auto-réparation qui redémarre seule le service DHCP arrêté (prouvé en 1 minute) | ✅ Terminé — 20/11/2026 |
| 17 | [Automatisation du lab isfo.com avec Ansible (Linux + Windows/WinRM)](travaux-pratiques/TP-Automatisation-Ansible.md) | Mettre en place Ansible comme outil d'automatisation du lab isfo.com : un nœud de contrôle Linux pilote les machines du lab et applique des configurations identiques, reproductibles et idempotentes, sur Linux et sur les serveurs Windows (contrôleurs de domaine), à partir de playbooks YAML versionnables | ✅ Terminé — 23/11/2026 |


**Prochainement** : l'héritage et l'ordre d'application **LSDOU** en pratique, les **PSO** (stratégies de mot de passe granulaires), et le **routage dynamique** (RIP, OSPF, EIGRP, BGP).


## 📁 Organisation du dépôt


- **`travaux-pratiques/`** — les comptes rendus complets de chaque TP
- **`scripts-powershell/`** — mes scripts d'administration Active Directory, commentés en français
- **`reseau-cisco/`** — configurations commentées de switches et routeurs Cisco — *en construction*


## 🛠️ Compétences mises en pratique


Administration Windows Server 2019 · Active Directory · Stratégies de groupe (création, liaison, héritage LSDOU, magasin central, préférences GPP, PSO) · DNS · DHCP · TCP/IP · VLAN · PowerShell · Routage et commutation Cisco · Supervision Zabbix 7.0 (serveur, agents, déclencheurs, tableau de bord, auto-réparation) · Automatisation Ansible (nœud de contrôle, playbooks YAML, templates Jinja2, handlers, WinRM)


## 🎓 Certifications et formation


- Badge Cisco **Networking Basics** (2026)
- Badge Cisco **Network Support and Security** (2026)
- **CCNA : en préparation**
- Baccalauréat Sciences Physiques


## 📫 Contact


- LinkedIn : [Hiba Khaddi](https://www.linkedin.com/in/hiba-khaddi-472ab7432/)
- Casablanca, Maroc — *en recherche d'un stage PFE en administration systèmes et réseaux*
