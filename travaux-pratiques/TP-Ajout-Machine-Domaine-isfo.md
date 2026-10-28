# TP — Ajout d'une machine au domaine isfo.com (pc-hiba)

## Objectif

Intégrer la machine **pc-hiba** au domaine Active Directory **isfo.com**, afin qu'elle soit gérée de manière centralisée (comptes, stratégies de groupe, sécurité).

## Environnement (vérifié sur la capture d'écran)

| Élément | Valeur |
|---|---|
| Machine ajoutée | **pc-hiba** |
| Nom complet de l'ordinateur | **pc-hiba.isfo.com** |
| Système d'exploitation | Windows Server 2019 |
| Domaine cible | **isfo.com** |
| Session affichée | hiba / hiba.isfo.com |
| Type d'appartenance avant l'opération | Groupe de travail (WORKGROUP) — option non sélectionnée dans la fenêtre |

## Procédure réalisée (interface graphique)

Chemin suivi, visible sur la capture :

1. **Panneau de configuration** > **Système et sécurité** > **Système**.
2. Ouvrir les **Propriétés système** (Modifier les paramètres) > onglet **Nom de l'ordinateur** > **Modifier**.
3. Dans la fenêtre **Modification du nom ou du domaine de l'ordinateur** :
   - **Nom de l'ordinateur :** pc-hiba
   - **Membre d'un :** cocher **Domaine** et saisir **isfo.com** (le groupe de travail WORKGROUP n'est plus sélectionné).
4. Cliquer sur **OK** et saisir les identifiants d'un compte autorisé à joindre la machine au domaine quand Windows le demande.

## Résultat vérifié

La fenêtre de confirmation suivante s'est affichée :

> **Bienvenue dans le domaine isfo.com.**

Ce message confirme que le contrôleur de domaine a accepté l'ajout de la machine pc-hiba au domaine isfo.com.

## Remarque

La mention **« Activer Windows »** apparaît sur la machine : elle n'est pas activée. Cela n'a aucun impact sur l'ajout au domaine.

## À vérifier / prochaines étapes (non visibles sur la capture, à confirmer)

- [ ] **Redémarrer pc-hiba** : le redémarrage est nécessaire pour que l'appartenance au domaine prenne effet.
- [ ] Après le redémarrage, ouvrir une session avec un compte du domaine (par exemple `ISFO\hiba`).
- [ ] Sur le contrôleur de domaine, vérifier que l'objet ordinateur **pc-hiba** apparaît dans **Utilisateurs et ordinateurs Active Directory**.
- [ ] Sur pc-hiba, vérifier l'appartenance avec `whoami` et la résolution du domaine (le DNS de la machine doit pointer vers le contrôleur de domaine), par exemple `ping isfo.com`.
- [ ] Vérifier ensuite que les stratégies de groupe (GPO) du domaine s'appliquent bien à pc-hiba (`gpresult /r`).
