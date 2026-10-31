# TP — Quota FSRM sur le partage Partage_EBA

## Objectif

Limiter l'espace disque occupé par le partage **Partage_EBA** grâce à un **quota FSRM** (Gestionnaire de ressources du serveur de fichiers) : au-delà de la limite, l'écriture est **bloquée** (quota inconditionnel), et un **seuil d'alerte à 85 %** prévient avant d'atteindre le plafond.

## Environnement

| Élément | Valeur vérifiée |
|---|---|
| Serveur | **SVR1** — Windows Server 2019, domaine **isfo.com** |
| Outil | Gestionnaire de ressources du serveur de fichiers (FSRM) → Gestion de quota → Quotas |
| Dossier limité | **C:\Partage_EBA** (le partage du TP « Énumération basée sur l'accès » : Commun, Hiba, Wiam) |
| Type de quota | **Inconditionnel** (bloquant) |
| Seuil de notification | **Avertissement à 85 %**, par message électronique |
| Modèle créé | **« mon quota »** (propriétés personnalisées enregistrées comme modèle) |

## Étape 1 — Créer le quota

1. Dans la console FSRM : **Gestion de quota → Quotas → Créer un quota**.
2. Chemin d'accès du quota : **C:\Partage_EBA**, option **« Créer un quota sur le chemin d'accès »**.
3. Choisir **« Définir des propriétés de quota personnalisées »** → bouton **Propriétés personnalisées**.

## Étape 2 — Régler la limite et le seuil d'alerte

Dans les propriétés du quota :

- **Limite d'espace** : quota **inconditionnel** coché — les utilisateurs ne peuvent pas dépasser la limite (avec un quota « conditionnel », ils le pourraient : il ne sert qu'à l'analyse).
- **Seuils de notification → Ajouter** : générer les notifications quand l'utilisation atteint **85 %**.
- Onglet **Message électronique** : cocher **« Envoyer un message à l'utilisateur qui dépasse le seuil »** (objet par défaut : « Seuil de quota de [Quota Threshold] % dépassé », avec les variables [Quota Path], [Quota Limit MB], [Quota Used MB]…).

Le quota apparaît ensuite dans les propriétés avec la ligne **« Avertissement (85 %) »** et la coche dans la colonne **Adresse électronique**.

## Étape 3 — Enregistrer les propriétés comme modèle

À la création, FSRM propose d'enregistrer les propriétés personnalisées sous forme de modèle : nom saisi **« mon quota »**. Le quota créé est alors adossé à ce modèle (colonne **Modèle source : mon quota**, **Modèle correspondant : Oui**) — les prochains quotas pourront réutiliser exactement ces réglages.

## Résultat dans la console

| Chemin d'accès du quota | % utilisé | Limite affichée | Type | Modèle source | Correspondant |
|---|---|---|---|---|---|
| C:\Partage_EBA | 4 % | 100 Ko | Inconditionnel | mon quota | Oui |

## Test réel — la copie bloquée

Test fait depuis l'Explorateur, dans **C:\Partage_EBA\Commun** :

1. Fichier de test choisi dans le magasin central : **WindowsUpdate.admx** (98,8 Ko), copié depuis `\\isfo.com\SYSVOL\isfo.com\Policies\PolicyDefinitions`.
2. Collage dans **Commun** → Windows refuse : **« Espace disque insuffisant sur Commun — […] Ko est nécessaire pour copier cet élément. Supprimez ou déplacez les fichiers pour avoir suffisamment d'espace. »**

Le quota inconditionnel fait donc bien son travail : quand la limite est atteinte, l'écriture est impossible, comme si le disque était plein.

## Point à vérifier

- Le **résumé de création** affichait « Limite : 100 Mo (Inconditionnel) », mais la **console affiche ensuite une limite de 100 Ko** (c'est cette petite limite qui rend le test de copie possible avec un fichier de 98,8 Ko). Valeur exacte à garder dans le rapport : **à confirmer** selon ce qui a été réglé à la fin du TP.

## À retenir

- **Inconditionnel = bloquant** (quota « dur ») ; **conditionnel = surveillance seulement** (quota « souple »).
- Le **seuil de 85 %** sert à prévenir **avant** le blocage : l'utilisateur reçoit le message d'avertissement.
- Enregistrer ses réglages comme **modèle** (« mon quota ») fait gagner du temps pour les quotas suivants et garde une configuration uniforme.
