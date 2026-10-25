# TP — Création d'un magasin central des modèles d'administration (ADMX/ADML)

**Environnement** : Windows Server 2019 (SVR1) — domaine Active Directory **isfo.com**
**Date de réalisation** : 23 octobre 2026 — ✅ TP validé

## 🎯 Objectif

Par défaut, l'éditeur de stratégie de groupe charge les modèles d'administration (fichiers ADMX) depuis le poste local (`C:\Windows\PolicyDefinitions`). Le **magasin central** place ces fichiers dans le dossier SYSVOL du domaine : tous les contrôleurs de domaine et tous les administrateurs utilisent alors **les mêmes définitions**, répliquées automatiquement.

## ✅ Prérequis

- Un contrôleur de domaine fonctionnel (ici SVR1.ISFO.COM)
- Un compte administrateur du domaine
- La console GPMC (`gpmc.msc`)

## 🛠️ Étapes (interface graphique)

### Étape 1 — Créer le dossier PolicyDefinitions dans SYSVOL
Ouvrir le chemin `\\isfo.com\SYSVOL\isfo.com\Policies` dans l'Explorateur, puis créer un dossier nommé exactement **PolicyDefinitions**.

### Étape 2 — Copier les fichiers ADMX
Depuis `C:\Windows\PolicyDefinitions`, copier **uniquement les fichiers .admx** vers le dossier `PolicyDefinitions` créé dans SYSVOL.

### Étape 3 — Copier les fichiers de langue ADML
Dans le dossier SYSVOL `PolicyDefinitions`, créer les sous-dossiers **fr-FR** et **en-US**, puis y copier les fichiers **.adml** correspondants depuis `C:\Windows\PolicyDefinitions\fr-FR` et `\en-US`.

### Étape 4 — Vérification
Ouvrir une GPO dans l'éditeur de stratégie de groupe, déployer **Configuration ordinateur → Stratégies → Modèles d'administration**. Le nœud doit indiquer :

> **« Modèles d'administration : définitions de stratégie (fichiers ADMX) récupérées à partir du magasin central »**

### Étape 5 — Réplication
Aucune action : SYSVOL réplique automatiquement le magasin central vers les autres contrôleurs de domaine (DFSR).

## ⚠️ Pièges classiques

1. **Mauvais emplacement** : `PolicyDefinitions` doit être créé **dans** le dossier `Policies` de SYSVOL, pas à la racine.
2. **ADML oubliés** : sans les fichiers de langue, l'éditeur affiche des erreurs « ressource introuvable ». ADMX et ADML sont indissociables.
3. **Éditeur déjà ouvert** : l'éditeur ne vérifie le magasin qu'à son ouverture — le fermer et le rouvrir après la copie des fichiers.

## 🏁 Résultat

Vérification réussie sur SVR1.ISFO.COM : les modèles d'administration sont chargés depuis le magasin central, avec les libellés en français (ADML fr-FR fonctionnels).
