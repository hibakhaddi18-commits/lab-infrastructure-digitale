# TP — Déduplication des données sur le volume H:

## Objectif

Réduire l'espace disque occupé sur un volume grâce à la **déduplication des données** : Windows analyse les fichiers, repère les blocs de données **identiques** (morceaux répétés d'un fichier à l'autre) et n'en conserve qu'**une seule copie**, les autres étant remplacés par des pointeurs. Les fichiers restent parfaitement lisibles pour les utilisateurs, mais le volume peut économiser une grande partie de son espace.

## Environnement

| Élément | Valeur vérifiée |
|---|---|
| Serveur | **SVR1** — Windows Server 2019, domaine **isfo.com** |
| Outil | **PowerShell** en tant qu'administrateur (`PS C:\Users\Administrateur.SVR1>`) |
| Fonctionnalité | **FS-Data-Deduplication** (« Déduplication des données ») |
| Volume traité | **H:** (volume de données — la déduplication ne s'active pas sur le volume système) |

## Étape 1 — Installer la fonctionnalité

```powershell
Install-WindowsFeature -Name FS-Data-Deduplication
```

Résultat obtenu :

| Success | Restart Needed | Exit Code | Feature Result |
|---|---|---|---|
| **True** | **No** | **Success** | {Déduplication des données} |

Installation réussie, **sans redémarrage** nécessaire.

## Étape 2 — Activer la déduplication sur le volume H:

```powershell
Enable-DedupVolume H:
```

Résultat obtenu :

| Enabled | UsageType | SavedSpace | SavingsRate | Volume |
|---|---|---|---|---|
| **True** | **Default** | 0 B | 0 % | **H:** |

Le type d'usage **Default** est le profil général (serveur de fichiers classique). À l'activation, l'espace économisé est encore de **0** : normal, aucun travail d'optimisation n'a encore tourné.

## Étape 3 — Lancer un travail d'optimisation manuel

```powershell
Start-DedupJob -Volume "H:" -Type Optimization
```

Résultat obtenu :

| Type | ScheduleType | StartTime | Progress | State | Volume |
|---|---|---|---|---|---|
| **Optimization** | **Manual** | — | 0 % | **Queued** | **H:** |

Le travail est **en file d'attente (Queued)** : il va analyser le volume et optimiser les fichiers éligibles.

## Commandes de suivi utiles

```powershell
Get-DedupStatus -Volume "H:"   # espace économisé, taux d'économie (SavingsRate)
Get-DedupJob                   # état des travaux en cours (progression %)
Get-DedupVolume -Volume "H:"   # vérifier que la déduplication est activée
```

## À retenir

- La déduplication travaille **en arrière-plan** : par défaut, des travaux planifiés tournent régulièrement, et on peut forcer un passage avec `Start-DedupJob -Type Optimization`.
- Seuls les fichiers **non modifiés depuis quelques jours** sont optimisés (âge minimal des fichiers) : un fichier tout juste créé ne donne donc pas d'économie immédiate — c'est normal si `SavedSpace` reste à 0 au début.
- Le gain se lit dans **`Get-DedupStatus`** : `SavedSpace` (espace récupéré) et `SavingsRate` (pourcentage économisé).
- Les utilisateurs ne voient **aucune différence** : les fichiers s'ouvrent normalement, la déduplication est transparente.
