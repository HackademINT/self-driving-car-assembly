---
title: "Préparation au TP"
subtitle: "TP1"
author: "Couprie Diaz, Soton, Védie, Duboc"
team: "Télécom SudParis"
titlepage: true
toc: true
toc-own-page: true
titlepage-color: "607D8B"
titlepage-text-color: "FFFFFF"
titlepage-rule-color: "FFFFFF"
titlepage-rule-height: 1
colorlinks: true
---

# PHY4501 — PRÉPARATION 1

## Alimentation de l'AT89C51

L’alimentation du véhicule est assurée par des batteries d’accumulateurs de type Ni-Cd ou Ni-Mh. \
La carte alimentation est conçue autour d’un circuit intégré LM7805 (U1).

### 1. Comparer ces deux technologies de batterie.

- rendement: les piles NiMH assurent un rendement supérieur à celui des
  piles standard NiCd impliquant une consommation plus élevé

- tension: les deux types de piles, NiMH et NiCd, fournissent une tension équivalente.

- capactié: les piles NiMH conservent plus de deux fois d’énergie que les piles standard NiCd. Elles assurent donc une plus longue durée de service (heures, nombre de clichés).

- effet mémoire: il est possible de faire une charge complète des piles NiMH en n’importe quel temps, sans en affecter la durée de vie. Pour obtenir le rendement optimal des piles NiCd, elles doivent être complètement déchargées avant d’être rechargées. Contrairement aux piles NiCd, les piles NiMH n’ont aucun effet mémoire.

- environnement: les piles NiMH ne contiennent aucun cadmium, matière dangereuse pour l’environnement.

![](images/comp.png){width=11cm}

\pagebreak

### 2. Quelles autres technologies sont couramment employées en modélisme 

- Les batteries au plomb sont les moins chères des batteries (ancienne
  technologie peu performante et très polluante). 

- Les batteries Lithium ion ont une grande capacité de stockage dans un faible volume avec un faible poids. 
Elles possèdent une grande capacité massique. Ces batteries n'acceptent pas de
surcharge sous peine d'exploser. Une gestion électronique est donc nécessaire. 

- Les batteries lithium polymère (Li-Po) sont une variante de la technologie lithium ion. 
Elles ont une densité énergétique et des caractéristiques à peu près similaires que les lithiums ion. 
Elles sont beaucoup utilisées dans le modélisme pour une question de poids. 
Cette technologie est un peu plus stable que le lithium ion. 
Sa recharge est plus compliquée et nécessite un chargeur adapté. 
Si la recharge n'est pas faite correctement la batterie prend feu. 
Son prix la rend moins attractive que la lithium ion.

- Les batteries lithium fer phosphate (LiFePO4) stocke un peu moins d'énergie que la technologie lithium ion mais elle est entièrement stable, sans risque d'incendie ou d'explosion. Son point fort est son grand nombre de cycles. Elle est capable de réaliser 4 fois plus de charge/décharge qu'une batterie lithium ion classique et 5 fois plus qu'une batterie au plomb. Elle commence à être utilisée dans beaucoup de domaines industriels. Elle présente l'avantage d'avoir une tension proche d'une batterie 12V plomb (12,8V au lieu de 12V). Cette technologie devrait remplacer à terme les batteries plomb. 

\pagebreak

### 3. Donner la fonction de ce circuit (en français).

Ce circuit est un régulateur de tension. 

Les régulateurs sont de très grande utilité dans les circuits électriques lorsque vous avez besoin d'une tension stable. En effet un régulateur permet de rentre la tension de sortie très fixe, ce qui est préférable pour des composants comme les microcontrôleurs. Par exemple pour un régulateur +5V, vous aurez au maximum une chute à +4.97V pour des courants élevés. Ce qui est beaucoup plus précis que des piles ou un adaptateurs secteurs 230V~ -> 5V-.

Le régulateur de tension positive à 3 bornes LM7805 utilise un limitation de courant interne, un arrêt thermique et une aire de fonctionnement sécurisé. Avec un dissipateur thermique adapté, il peut fournir un courant de sortie supérieur à 1A. Bien qu'il soit initialement conçu comme un régulateur de tension fixe, ce dispositif peut être utilisé avec des composants externes pour obtenir des courants et des tensions ajustables.

- Courant de sortie jusqu'à 1 A
- Protection contre les surcharges thermiques
- Protection contre les courts-circuits
- Aire de fonctionnement sécurisé des transistors de sortie
- Aire de fonctionnement sécurisé des transistors de sortie

### 4. Donner la tension de sortie du LM7805.

Tension de sortie: 5V

### 5. Donner les tensions maximale et minimale du LM7805.

Tension minimale: 10V
Tension maximale: 35V

### 6. Donner les courants de sortie nominale et pic du LM7805.

Courant de sortie: 1A

\pagebreak

### 7.1 Quelles cartes du véhicule sont alimentées par la carte alimentation ? 

Les cartes alimentées sont les cartes, Maître, Esclave, Sirene et Détection Piste

### 7.2 Quel est le rôle de la capacité branchée en parallèle à l’alimentation sur ces cartes.

La capacité branchée en parallèle fait office de filtre.

### 8. Comment sont alimentées les autres cartes ?

Les autres cartes sont alimentées par la batterie 1.
