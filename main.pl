/* File main.pl */
/* Genshin Sekai */

/*
Anggota Kelompok :
    1. Muhammad Azhar Faturrahman (13519020)
    2. Daru Bagus Dananjaya (13519080)
    3. Karel Renaldi (13519180)
    4. Rayhan Asadel (13519196)
    5. Muhammad Dehan Al Kautsar (13519200)
*/

/* Import Modul yang akan digunakan */
:- use_module(library(random)).

/* Dynamic predicate */
/* TBD */

/* Inisialisasi Game */
/* Menyatakan stauts keberlangsungan game, */
/* gameOn(1) : permainan berjalan, player masih hidup */
/* gameOn(0) : permainan berakhir, player terbunuh */
gameOn(1).

/* Deklarasi Fakta */
/* CHARACTER PEMAIN */
char_name(kirito).
char_jobs(swordsman).
char_jobs(archer).
char_jobs(sorcerer).

/* ENEMY */
enemy_common(slime).
enemy_common(goblin).
enemy_common(wolf).
enemy_boss(sauron).

/* ITEM */
/* Item Jobs Swordsman */
item(weapon,wooden_sword).
item(weapon,iron_sword).
item(weapon,diamond_sword).

/* Item Jobs Archer */
item(weapon,wooden_bow).
item(weapon,iron_bow).
item(weapon,diamond_bow).

/* Item Jobs Sorcerer */
item(weapon,wooden_staff).
item(weapon,iron_staff).
item(weapon,diamond_staff).

/* Armor */
item(armor,security_vest).
item(armor,police_vest).
item(armor,military_vest).

/* ULTRA RARE ITEM */
item(weapon,keris).         /* one hit man */
item(armor,batik).
item(acc,powerbalance).     /* invisible, no one can hit you */
item(potion,jamu).

/* Accessories */
item(acc,hankerchief).
item(acc,batu_akik).
item(acc,anting_jamet).
item(acc,topi_pramuka).
item(acc,kalung_corona).

/* Potion */
item(potion,freshcare).
item(potion,bodrex).
item(potion,antangin).
