# TP — Énumération basée sur l'accès (EBA) sur un partage Windows Server

## Objectif

Faire en sorte qu'un utilisateur ne voie, dans un partage réseau, **que les dossiers qu'il a le droit de lire**. Sans EBA, il voit tous les dossiers (avec « Accès refusé » sur ceux qu'il ne peut pas ouvrir) ; avec l'EBA, les autres dossiers sont **invisibles**, ce qui protège aussi leurs noms.

## Environnement

| Élément | Valeur vérifiée |
|---|---|
| Serveur | **SVR1** |
| Domaine | **isfo.com** |
| Partage | **Partage_EBA** — `\\SVR1\Partage_EBA` |
| Sous-dossiers | **Commun**, **Hiba**, **Wiam** |
| Postes de test | pc-hiba, session **hiba** (compte simple, pas administrateur) |

## Étape 1 — Créer le partage et activer l'EBA

1. Sur SVR1, créer le dossier du partage, puis les trois sous-dossiers `Commun`, `Hiba` et `Wiam`.
2. Partager le dossier en **partage avancé** sous le nom `Partage_EBA` (les vraies restrictions se font au niveau NTFS, étape 2).
3. Activer l'EBA : **Gestionnaire de serveur → Services de fichiers et de stockage → Partages** → clic droit sur `Partage_EBA` → **Propriétés → Paramètres** → cocher **« Activer l'énumération basée sur l'accès »**.

En PowerShell (administrateur), c'est la même chose :

```powershell
Set-SmbShare -Name Partage_EBA -FolderEnumerationMode AccessBased
Get-SmbShare -Name Partage_EBA | Select Name, FolderEnumerationMode
# Doit afficher : AccessBased
```

## Étape 2 — Mettre les droits NTFS (c'est la base, l'EBA ne les remplace pas)

- **Commun** : accessible à tous les utilisateurs du domaine (lecture) — c'est le dossier que tout le monde doit voir.
- **Hiba** : seulement `hiba` (+ Système et Administrateurs).
- **Wiam** : seulement `wiam` (+ Système et Administrateurs).

Pour chaque dossier privé : Propriétés → onglet **Sécurité** → **Avancé** → **Désactiver l'héritage** → choisir **« Convertir les autorisations héritées en autorisations explicites »**, puis retirer le groupe qui donne accès à tout le monde.

## Piège n° 1 — Le groupe « Utilisateurs » donnait lecture à tout le monde

Premier test depuis pc-hiba : **tout restait visible**, alors que l'EBA était bien cochée et enregistrée (bouton « Appliquer » grisé = aucune modification en attente).

Cause trouvée sur l'onglet Sécurité du dossier `Wiam` : le groupe **Utilisateurs (ISFO\Utilisateurs)** y avait le droit de lecture. Ce groupe contient tous les utilisateurs du domaine, donc `hiba` aussi — tant que `hiba` peut lire `Wiam`, l'EBA l'affiche, même activée.

Correction : retirer **Utilisateurs (ISFO\Utilisateurs)** de `Wiam`, puis faire pareil pour `Hiba`. Le dossier `Commun`, lui, garde ce groupe.

## Piège n° 2 — « Supprimer » au lieu de « Convertir » en désactivant l'héritage

En corrigeant `Hiba`, l'héritage a été désactivé avec **« Supprimer toutes les autorisations héritées »** au lieu de « Convertir » : le partage entier `\\SVR1\Partage_EBA` est alors devenu inaccessible (« Accès refusé » / partage introuvable), parce que la racine avait perdu tous ses droits.

Réparation, sur SVR1 en administrateur : rouvrir les propriétés **Sécurité** de la racine `Partage_EBA` et y remettre **Utilisateurs (ISFO\Utilisateurs)** en Lecture (si les propriétés sont inaccessibles : **Avancé → Propriétaire → Administrateurs**, puis refaire l'étape). Vérifier aussi l'onglet **Partage → Partage avancé → Autorisations**.

**Leçon à retenir :** en désactivant l'héritage, toujours choisir **« Convertir »**, jamais « Supprimer ».

## Résultat validé — 28 octobre 2026

Depuis pc-hiba, en session **hiba** :

| Dossier | Visible pour hiba ? |
|---|---|
| Commun | ✅ Oui |
| Hiba | ✅ Oui |
| Wiam | ❌ Invisible |

C'est exactement le but de l'énumération basée sur l'accès : `Wiam` est masqué pour `hiba`, sans message « Accès refusé ».

## Tests restants (proposés, non confirmés)

- [ ] Session **wiam** : doit voir `Commun` + `Wiam` uniquement.
- [ ] Session **Tri3** (compte simple, ni hiba ni wiam) : doit voir `Commun` seul.
- [ ] Rappel : un compte **administrateur** voit tout par définition — le test doit se faire avec un compte simple. Après un changement de droits, actualiser l'Explorateur (F5) ou rouvrir `\\SVR1\Partage_EBA` ; `net use * /delete` ne sert que si un lecteur réseau est mappé (« La connexion réseau est introuvable » = il n'y en avait pas à supprimer).
