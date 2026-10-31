# TP — Filtrage de fichiers FSRM : bloquer les images dans Partage_EBA

## Objectif

Empêcher le dépôt de certains types de fichiers dans le partage **Partage_EBA** grâce au **filtrage de fichiers FSRM** : ici, bloquer les **fichiers image**. Un filtrage **actif** refuse l'écriture ; un filtrage **passif** se contenterait d'observer et de journaliser.

## Environnement

| Élément | Valeur vérifiée |
|---|---|
| Serveur | **SVR1** — Windows Server 2019, domaine **isfo.com** |
| Outil | Gestionnaire de ressources du serveur de fichiers (FSRM) → Gestion du filtrage de fichiers → Filtres de fichiers |
| Dossier filtré | **C:\Partage_EBA** (Commun, Hiba, Wiam) |
| Modèle utilisé | **« Bloquer les fichiers image »** (modèle intégré) |
| Type de filtrage | **Actif** |
| Groupe de fichiers | **Fichiers image** |
| Notifications | Adresse de messagerie + Journal des événements |

## Étape 1 — Créer le filtre de fichiers

1. Dans la console FSRM : **Gestion du filtrage de fichiers → Filtres de fichiers → Créer un filtre de fichiers**.
2. Chemin d'accès du filtre de fichiers : **C:\Partage_EBA** (bouton Parcourir → Disque local (C:) → Partage_EBA).
3. Choisir **« Dériver les propriétés de ce modèle de filtre de fichiers (recommandé) »** et sélectionner le modèle **« Bloquer les fichiers image »**.

## Étape 2 — Vérifier le résumé avant de créer

Le résumé des propriétés du filtre de fichiers affiche :

- **Filtre de fichiers : C:\Partage_EBA**
- **Modèle source : Bloquer les fichiers image**
- **Type de filtrage : Actif**
- **Groupes de fichiers : Fichiers image**
- **Notifications : Adresse de messagerie, Journal des événements**

→ Bouton **Créer**. Le filtre s'applique au dossier **et à ses sous-dossiers** (Commun, Hiba, Wiam sont donc tous protégés).

## Test réel — la copie d'une image refusée

Test fait depuis l'Explorateur, dans le dossier **C:\Partage_EBA** :

1. Copie d'un **fichier image** vers le partage.
2. Windows refuse immédiatement : **« Erreur lors de la copie du fichier ou du dossier — Accès refusé. »**

Le filtrage actif fonctionne : le fichier image ne peut pas entrer dans le partage, alors que les autres types de fichiers (documents, texte…) restent autorisés.

## À retenir

- **Filtrage actif** = le fichier interdit est **refusé** ; **filtrage passif** = il est seulement **surveillé** (utile pour analyser avant de bloquer).
- Le filtrage s'appuie sur des **groupes de fichiers** (extensions) : « Fichiers image », « Fichiers audio et vidéo », « Fichiers exécutables »… et sur des **modèles** prêts à l'emploi (« Bloquer les fichiers image », « Bloquer les fichiers audio et vidéo »…).
- Le message côté utilisateur est un simple **« Accès refusé »** : c'est volontaire, Windows ne dit pas que c'est le filtrage qui bloque.
- Le filtre posé sur **C:\Partage_EBA** protège aussi **tous ses sous-dossiers**.
