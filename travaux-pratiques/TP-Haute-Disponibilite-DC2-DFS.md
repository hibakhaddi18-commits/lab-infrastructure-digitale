# TP — Haute disponibilité des services : 2ᵉ contrôleur de domaine, espace de noms DFS et réplication DFSR

## Objectif

Rendre les services du domaine **isfo.com** tolérants à la panne d'un serveur :

1. Promouvoir un **deuxième contrôleur de domaine** pour l'Active Directory et le DNS.
2. Publier les dossiers partagés derrière un **espace de noms DFS** unique : `\\isfo.com\Partage`.
3. **Répliquer** automatiquement le dossier `Partage_EBA` entre les deux serveurs (DFSR).
4. **Prouver la continuité de service** : arrêter complètement SVR1 et continuer à lire **et écrire** dans les dossiers depuis un poste client.

## Environnement

| Élément | Détail |
|---|---|
| Domaine | isfo.com |
| SVR1 | Windows Server 2019 — 192.168.1.113 — DC principal, héberge C:\Partage_EBA (Commun, Hiba, Wiam) |
| SVR_2 | Windows Server 2019 — 192.168.1.50 — nouveau serveur promu 2ᵉ contrôleur de domaine |
| pc-hiba | Poste client du domaine — 192.168.1.11 — session de test **tri3** |
| Virtualisation | VMware Workstation |

## Phase 0 — Préparation de SVR_2

- Nom du serveur : **SVR_2**, adresse IP fixe **192.168.1.50/24**, DNS pointant sur SVR1 (192.168.1.113).
- Premier blocage : la promotion échouait (« Impossible de contacter un contrôleur de domaine ») et le ping échouait **dans les deux sens** → les deux machines virtuelles n'étaient pas sur le même réseau virtuel. Après correction du réseau virtuel : ping OK dans les deux sens.

## Phase 1 — Promotion de SVR_2 en contrôleur de domaine

- Installation du rôle **AD DS** puis promotion comme contrôleur de domaine supplémentaire de **isfo.com** (installation DNS incluse).
- Résultat : deux contrôleurs de domaine pour le même domaine — l'authentification et la résolution DNS survivent à l'arrêt de l'un d'eux.

## Phase 2 — Espace de noms DFS

- Installation des rôles **Espaces de noms DFS** et **Réplication DFS** sur les deux serveurs.
- Création de l'espace de noms basé sur le domaine : **`\\isfo.com\Partage`** (mode Windows Server 2008, racine hébergée dans `C:\DFSRoots\Partage`).
- **Serveurs d'espaces de noms : SVR1 et SVR_2** — le nom `\\isfo.com\Partage` peut donc être servi par les deux.
- Sur SVR_2, préparation du dossier jumeau : `C:\Partage_EBA` avec les sous-dossiers **Commun, Hiba, Wiam — vides** (aucune copie manuelle : c'est la réplication qui les remplira), partagé sous le nom **Partage_EBA**, avec l'**énumération basée sur l'accès (EBA) activée** sur le partage.

## Phase 3 — Dossier DFS et groupe de réplication

- Création du dossier DFS **Partage_EBA** dans l'espace de noms, avec **deux cibles** : `\\SVR1\Partage_EBA` et `\\SVR_2\Partage_EBA`.
- Création du groupe de réplication proposé par l'assistant :
  - Type : **groupe multi-usages** ; membres : SVR1 + SVR_2
  - Topologie : **maille complète** (chaque serveur réplique avec l'autre)
  - **Membre principal : SVR1** (sa copie fait foi pour la réplication initiale)
  - Dossier répliqué : Partage_EBA (`C:\Partage_EBA` sur les deux serveurs)
  - Planification : en continu, **bande passante complète**
- Assistant terminé avec les 7 tâches en « Réussite » (groupe, membres, dossier répliqué, connexions…).

**Test de réplication** : création de `test-replication.txt` dans le Commun de SVR1 → le fichier apparaît tout seul dans `C:\Partage_EBA\Commun` sur SVR_2 ✅

## Phase 4 — Vérifications métier avant le test de panne

1. **Énumération basée sur l'accès à travers DFS** : depuis le poste client, session **tri3**, le chemin `\\isfo.com\Partage\Partage_EBA` ne doit montrer que **Commun**.
   - Premier constat : tri3 voyait aussi le dossier **Hiba**. Cause : l'ACL NTFS du dossier Hiba accordait **Lecture à Tri3** (et hiba n'y figurait pas). Correction de l'ACL : **hiba seul** en lecture (+ Système et Administrateurs). L'EBA n'était pas en cause : elle affiche ce que l'utilisateur a le droit de lire.
   - Après correction : tri3 ne voit que **Commun** ✅ (Hiba et Wiam invisibles).
2. **DNS du poste client** : pc-hiba ne connaissait que SVR1 (192.168.1.113). Ajout de **SVR_2 (192.168.1.50) comme DNS auxiliaire** — sans cela, l'arrêt de SVR1 aurait aussi coupé la résolution du nom isfo.com, et le test aurait échoué pour une mauvaise raison.

## Phase 5 — Test de bascule (panne simulée de SVR1)

Scénario exécuté et filmé (voir la vidéo de démonstration) :

1. **Arrêt complet de SVR1** (extinction de la machine virtuelle).
2. Depuis pc-hiba, session tri3 : réouverture de `\\isfo.com\Partage\Partage_EBA` → **Commun seul** visible, comme avant ✅
3. Lecture de `test-replication.txt` → OK ✅
4. Vérification de la cible active (Propriétés du dossier → onglet **DFS**) : l'espace de noms est servi par **SVR_2 (Actif : Oui)**, SVR1 inactif ✅
5. **Écriture pendant la panne** : création de `test-panne.txt` dans Commun → réussie via SVR_2 ✅
6. **Redémarrage de SVR1** → après quelques minutes, `test-panne.txt` apparaît tout seul dans `C:\Partage_EBA\Commun` sur SVR1 : la réplication a **rattrapé le retard automatiquement** ✅

## Problème rencontré pendant le test de bascule

- **Symptôme** : pendant la panne, la lecture fonctionnait mais la **création de fichier était refusée** pour tri3.
- **Diagnostic** (invite de commandes sur SVR_2) : `net share Partage_EBA` révélait **« Autorisation : Tout le monde, READ »** — le partage de SVR_2 était en **lecture seule**, alors que les droits NTFS de Commun autorisaient bien la modification. Le droit effectif par le réseau est toujours le **plus restrictif** des deux couches (partage × NTFS).
- **Piège supplémentaire** : la commande `net share Partage_EBA /GRANT:"Tout le monde",FULL` a échoué (erreur 3505) sur ce Windows en français → correction faite par l'interface graphique (Propriétés du partage → Autorisations → Contrôle total), puis reconnexion de la session cliente pour appliquer le nouveau droit.
- **Leçon** : la réplication DFSR réplique les fichiers et les ACL **du contenu**, mais **ni les autorisations de partage ni l'ACL du dossier racine répliqué** — chaque serveur doit donc être configuré de façon identique, à la main.

## Résultat final

- Deux contrôleurs de domaine AD + DNS pour isfo.com.
- Un seul chemin d'accès pour les utilisateurs : `\\isfo.com\Partage\Partage_EBA`, indépendant du serveur qui répond.
- Réplication bidirectionnelle automatique des fichiers et de leurs droits.
- Énumération basée sur l'accès respectée à travers DFS (tri3 → Commun uniquement).
- **Continuité de service prouvée en conditions réelles** : arrêt total du serveur principal, lecture et écriture maintenues, resynchronisation automatique à son retour.

## Compétences mises en œuvre

- Administration Windows Server 2019, Active Directory DS et DNS
- DFS Namespace (espaces de noms basés sur un domaine) et DFS Replication (groupes multi-usages, topologie en maille complète, membre principal)
- Gestion fine des autorisations : partages SMB, ACL NTFS, énumération basée sur l'accès
- Méthodologie de test de haute disponibilité et diagnostic méthodique (isolation de la couche fautive : DNS, référence DFS, partage, NTFS)
