# TP — Configuration du basculement (failover) d'une étendue DHCP

## Objectif

Assurer la continuité du service DHCP sur l'étendue **192.168.1.0** grâce au basculement (failover) entre deux serveurs DHCP : si l'un des serveurs tombe en panne, l'autre continue à distribuer les adresses IP aux clients.

## Environnement (vérifié sur la capture d'écran)

| Élément | Valeur |
|---|---|
| Console DHCP ouverte sur | svr2.lab.local (serveur local) |
| Étendue concernée | **192.168.1.0** |
| Serveur partenaire | **svr1.lab.local** |
| Nom de la relation de basculement | svr1.lab.local-192.168.1.115 |
| Onglet consulté | Propriétés de l'étendue > **Basculement** |

## Configuration relevée (onglet Basculement)

| Paramètre | Valeur |
|---|---|
| Mode | **Équilibrage de charge** (Load Balance) |
| Délai de transition maximal du client (MCLT) | **1 h 0 min** |
| Intervalle de basculement d'état | **Désactivé** |
| État de ce serveur | **Normale** |
| État du serveur partenaire | **Non disponible** |
| Pourcentage d'équilibrage de charge — serveur local | **50 %** |
| Pourcentage d'équilibrage de charge — serveur partenaire | **50 %** |

## Ce que signifie cette configuration

- **Mode Équilibrage de charge :** les deux serveurs DHCP distribuent les baux en parallèle, chacun prenant en charge la moitié des demandes (50 % / 50 % ici).
- **MCLT (1 h) :** durée maximale pendant laquelle un client peut conserver son bail sans que le serveur partenaire en soit informé. En cas de panne d'un serveur, le survivant ne prolonge les baux que dans la limite de ce délai.
- **Intervalle de basculement d'état désactivé :** le basculement d'état automatique après un délai n'est pas activé ; le serveur partenaire ne passe pas automatiquement en état de secours après un temps donné.

## Point d'attention (visible sur la capture)

L'**état du serveur partenaire est « Non disponible »** : au moment de la capture, svr1.lab.local n'est pas joignable ou pas visible depuis ce serveur. Tant que le partenaire reste indisponible, le basculement ne peut pas être effectif : un seul serveur distribue réellement les adresses.

## À vérifier (non visible sur la capture, à confirmer)

- [ ] Service DHCP **démarré** sur svr1.lab.local comme sur svr2.lab.local.
- [ ] Connectivité réseau entre les deux serveurs (le basculement DHCP utilise le port TCP **647** — à vérifier côté pare-feu).
- [ ] La relation de basculement apparaît aussi sur svr1.lab.local, avec l'état inverse (ce serveur « Normale », partenaire « Normale »).
- [ ] Après résolution, l'état du partenaire doit passer à **Normale** dans cet onglet.
- [ ] Test de basculement : arrêter le service DHCP d'un des deux serveurs et vérifier que l'autre continue à attribuer des adresses aux clients de l'étendue 192.168.1.0.
