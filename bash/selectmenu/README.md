# selectmenu

Permet de créer un menu de navigation par touches fléchées.

Options             | Description                                                                                                  |
:-------------------| :------------------------------------------------------------------------------------------------------------|
-ro                 | Retourne dans $REPLY l'offset de la selection en partant de 1, plutot que le libellé de la selection         |
-s<offset>          | Préselectionne un élément. Par défaut 1. Pour ne rien préselectionner, entrer -s0                            |
-a<nb colonnes>     | Aligne la sélection sur une colonne de n caractères. Par défaut, s'aligne sur la taille du plus grand élément|


Retours   | Valeurs                                     |
:---------|:--------------------------------------------|
Exit code | 1 si la touche escape est appuyée (abandon) |
$REPLY    | Contient la valeur de la selection          |