# TP — Gérer un serveur Windows Server 2019 Core avec Windows Admin Center

**Objectif :** administrer à distance un serveur Windows Server 2019 Core (sans interface graphique) depuis un navigateur, avec Windows Admin Center (WAC).

**Environnement :**
- VMware Workstation, 2 machines virtuelles :
  - **Windows Server 2019** (avec expérience de bureau) : c'est depuis cette VM que Windows Admin Center est ouvert dans le navigateur.
  - **Windows Server 2019 Core** : le serveur à administrer, nommé **svrcore**.
- Le serveur Core n'est **pas joint à un domaine** : il est en **WORKGROUP** (groupe de travail). C'est pour cela que la connexion utilise les identifiants de l'administrateur local et la configuration des hôtes de confiance (TrustedHosts).

## Étape 1 — Ouvrir Windows Admin Center

1. Sur la VM Windows Server 2019 (interface graphique), ouvrir le navigateur.
2. Rechercher « Windows Admin Center » et ouvrir la page d'accueil WAC.
3. WAC démarre (« Starting Windows Admin Center », puis « Collecte d'informations sur l'environnement ») et affiche la page **Toutes les connexions**.

## Étape 2 — Vérifier que WinRM tourne sur le serveur Core

Sur la console du serveur Core, en PowerShell :

```powershell
powershell
Get-Service
```

Résultat vérifié : le service **WinRM (Gestion à distance de Windows)** est à l'état **Running**.
C'est ce service qui permet à Windows Admin Center de piloter le serveur à distance.

## Étape 3 — Préparer la connexion côté WAC

Comme le serveur Core est en WORKGROUP (pas de domaine, donc pas de confiance Active Directory), la machine WAC doit l'autoriser explicitement :

```powershell
# Ajouter le serveur Core aux hôtes de confiance WinRM
Set-Item WSMan:\localhost\Client\TrustedHosts -Value "NOM_OU_IP_DU_SERVEUR_CORE" -Force

# Vérifier la connectivité réseau et le port WinRM (5985) depuis la machine WAC
Test-NetConnection -ComputerName "NOM_OU_IP_DU_SERVEUR_CORE" -Port 5985
# Le résultat TcpTestSucceeded doit être à True
```

## Étape 4 — Ajouter le serveur dans Windows Admin Center

1. Dans WAC, cliquer sur **Ajouter** → **Ajouter manuellement**.
2. Choisir **Serveurs** → **Ajouter**.
3. Dans « Nom du serveur », saisir **svrcore**.
4. Renseigner les identifiants de connexion (compte **Administrateur** local du serveur Core).
5. Valider : le serveur apparaît dans la liste des connexions.

## Étape 5 — Se connecter au serveur

1. Cliquer sur le serveur **svrcore** dans la liste.
2. Confirmer les informations d'identification (case « Utiliser ces informations d'identification pour toutes les connexions » disponible) puis **Continuer**.
3. WAC affiche « Connexion en cours… », puis ouvre le **Gestionnaire de serveur** du Core.

## Résultats vérifiés — Vue d'ensemble de svrcore

| Élément | Valeur constatée |
|---|---|
| Nom de l'ordinateur | svrcore |
| Domaine | WORKGROUP (ordinateur en groupe de travail) |
| Système d'exploitation | Windows Server 2019 |
| Version | 10.0.17763 |
| Processeur | Intel(R) Core(TM) i3-6006U CPU @ 2.00GHz (4 processeurs logiques) |
| Fabricant / Modèle | VMware, Inc. / VMware7,1 |
| Mémoire installée (RAM) | 2 Go |
| Espace disque (C:) | 32,0 Go libres sur 49,8 Go |
| Mode de langue PowerShell | Langue complète (FullLanguage) |
| Statut de Sauvegarde Azure | Non inscrit |

Le panneau latéral donne ensuite accès à tous les outils d'administration : Vue d'ensemble, Paramètres, Fichiers, Réseau, Services, Rôles et fonctionnalités, PowerShell, Registre, etc.

## Remarques

- **WORKGROUP, pas de domaine :** sans Active Directory, l'administration passe par le compte administrateur local + TrustedHosts. En domaine, la connexion serait transitive via les identifiants du domaine.
- **Activation Windows :** une notification « Activation nécessaire » apparaît sur la VM (Windows n'est pas activé sur cet appareil). Cela n'empêche pas l'administration via WAC, mais c'est à régulariser sur une machine de production.
- **Aucun mot de passe n'est noté dans ce compte rendu** : les identifiants saisis dans WAC restent confidentiels.

## Conclusion

Le serveur Core **svrcore** est désormais administrable entièrement depuis le navigateur via Windows Admin Center : ajout manuel, connexion avec le compte administrateur local, et vue d'ensemble complète (système, processeur, RAM, disque) vérifiée. La méthode est reproductible pour tout autre serveur Core en WORKGROUP, à condition que WinRM soit en cours d'exécution et que le port 5985 soit joignable.
