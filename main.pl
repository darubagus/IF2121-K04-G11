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
:- dynamic(char/3, attack/2, defense/2, max_HP/1, health/2,
   weapon/1, armor/1, acc/1, inventory/1, money/1,
   player_pos/2, enemy_pos/3, quest/5, kill_count/4, kill_Boss_Status/1, 
   turn/1, current_enemy/4, gameOn/1).
/* char(Jobs,Level,Exp), attack(Att,BonusAtt), defense(Def,BonusDef), max_HP(Darah_Maksimal),  
 * health(Darah,BonusDarah), weapon(Senjata), armor(Armor), acc(Aksesoris),
 * inventory(List), player_pos(X,Y), enemy_pos(X,Y,Lv), quest(quest_lv,kill_slime,kill_goblin,kill_wolf,kill_sauron),
 * kill_count(slime,goblin,wolf,sauron), kill_Boss_Status(status), turn(jumlah_turn), current_enemy(current_HP,Lv,X_Pos,Y_Pos)  */
/*
char(Jobs,Level,Exp),
New_Level is Level + 1,
retract(char(_,_,_)),
asserta(char(Jobs,New_Level,Exp)).
*/

/* inventory = [List]
inventory(X),
konso(E,X,Y),
retract(inventory(_)),
asserta(inventory(Y)).
*/
/* Inisialisasi Game */
/* Menyatakan status keberlangsungan game, */
/* gameOn(1) : permainan berjalan, player masih hidup */
/* gameOn(0) : permainan berakhir, player terbunuh, atau permainan belum dimulai */ /*
gameOn(1).
kill_Boss_Status(0).
*/

/* ENEMY */
/* enemy_type(lv,kind,attack,defense,health)*/
enemy_type(1,slime,30,5,30).
enemy_type(2,goblin,60,10,60).
enemy_type(3,wolf,90,20,120).
enemy_type(4,sauron,150,50,500).

/* ITEM */
/* item_weapon(tingkat senjata, char_jobs, char_weapon, kekuatan) */

/* Item Jobs Swordsman */
item_weapon(1,swordsman,wooden_sword,10).
item_weapon(2,swordsman,iron_sword,25).
item_weapon(3,swordsman,diamond_sword,50).

/* Item Jobs Archer */
item_weapon(1,archer,wooden_bow,10).
item_weapon(2,archer,iron_bow,25).
item_weapon(3,archer,diamond_bow,50).

/* Item Jobs Sorcerer */
item_weapon(1,sorcerer,wooden_staff,10).
item_weapon(2,sorcerer,iron_staff,25).
item_weapon(3,sorcerer,diamond_staff,50).

/* Armor */
/* item_armor(tingkat pelindung, char_armor, defense) */
item_armor(1,security_vest,10).
item_armor(2,police_vest,25).
item_armor(3,military_vest,50).

/* ULTRA RARE ITEM */
/* item_rare(weapon,keris).         /* one hit man 
  *item_rare(armor,batik).
  *item_rare(acc,powerbalance).     /* invisible, no one can hit you 
  *item_rare(potion,jamu).*/

/* Accessories */
item_acc(1,masker,health).
item_acc(2,batu_akik,health).
item_acc(1,anting_jamet,attack).
item_acc(2,topi_pramuka,attack).
item_acc(1,kalung_corona,defense).
item_acc(2,powerbalance,defense).

/* Potion */
item_potion(freshcare,health).
item_potion(bodrex,attack).
item_potion(antangin,defense).

/*Run command*/

run(map):- map_show.
run(status):- status.
run(inventory):- open_inventory,!.
run(w):- gerak(w), nl,!.
run(a):- gerak(a), nl,!.
run(s):- gerak(s), nl,!.
run(d):- gerak(d), nl,!.
run(help):- help,nl,!.
run(attack):- info_enemy,nl,!.
run(store):- shop,nl,!.
run(quest):- quest,nl,!.
run(quit) :- halt.
run(teleport):- teleport,nl,!.

/* ini menang
cekMenang:- 
    killBoss(X), 
    X==1. */
/* ini kalah
cekMenang:- 
    gameOn(X), X==0. */
/* Game Looping */
game_cond :-
    gameOn(1),
    repeat,
        write('> '),
        read(Command),
        run(Command),
        (killBoss(1) ; gameOn(0)), !, write('selamat!') ,halt.
        /* perulangan game*/


/* Basic rules */
/* Fungsi-Fungsi Dasar */


writeList([]):- nl.
writeList([H|T]):-
    write('->'),write(H),nl,
    writeList(T).

isListEmpty([]).

konso(X,L,[X|L]).

isMember(X, [X|_]).
isMember(X, [Y|Z]) :- 
    X\==Y, isMember(X,Z).
    
delElmt(_,[],[]).
delElmt(X,[X|Xs],Xs).
delElmt(X,[Y|Xs],[Y|Ys]) :- 
    X\==Y, delElmt(X,Xs,Ys).

count([],0).
count([_|Tail], N) :- count(Tail, N1), N is N1 + 1.

isMember(X, [X|_]).
isMember(X, [Y|Xs]) :-
    X \= Y,
    isMember(X,Xs).


/* Ukuran peta : 12x22 */
/* Peta terdefinisi dari 0..11 dan 0..21 */
/* Hanya bisa diakses dari 1..10 dan 1..20 */
   

/* STATUS */
status :- 
    char(Jobs,Level,Exp),
    kill_count(Slime,Goblin,Wolf,Sauron),
    attack(Att,BonusAtt),
    defense(Def,BonusDef),
    money(Uang),
    health(Hp,BonusHp),
    DisplayAtt is Att+BonusAtt,
    DisplayDef is Def+BonusDef,
    DisplayHP is Hp+BonusHp,
    write('Jobs         = '), write(Jobs),nl,
    write('Level        = '), write(Level),nl,
    write('Experience   = '), write(Exp),nl,
    write('Health       = '), write(DisplayHP),nl,
    write('Attack       = '), write(DisplayAtt),nl,
    write('Defense      = '), write(DisplayDef),nl,
    write('Money        = '), write(Uang),nl,
    write('Kill Count   = '),nl,
    write('     -> Slime  : '),write(Slime),nl,
    write('     -> Goblin : '),write(Goblin),nl,
    write('     -> Wolf   : '),write(Wolf),nl.
    write('     -> Sauron   : '),write(Sauron),nl.
            
/* BUKA_INVENTORY */
open_inventory :-
    inventory(Inv),
    write('Your inventory = '), nl, writeList(Inv),nl,nl,
    write('<3<3<3<3<3<3<3<3<3<3<3<3<3<3<3<3<3<3<3'),nl,
    write('<3                                  <3'),nl,
    write('<3    Choose What You Want to Do:   <3'),nl,
    write('<3                                  <3'),nl,
    write('<3  1. Use Weapon                   <3'),nl,
    write('<3  2. Use Armor                    <3'),nl,
    write('<3  3. Use Potion                   <3'),nl,
    write('<3  4. Quit                         <3'),nl,
    write('<3                                  <3'),nl,
    write('<3<3<3<3<3<3<3<3<3<3<3<3<3<3<3<3<3<3<3'),nl,
    write('>'),
    read(X),
    X >= 1, X < 4,!,
    utilize(X),nl.

utilize(X):-
    X == 1,!,
    write('Masukkan nama senjata : '),nl,
    write('> '),
    read(Senjata),
    using_weapon(Senjata),nl.

utilize(X):-
    X == 2,!,
    write('Masukkan nama pelidung : '),nl,
    write('> '),
    read(Pelindung),
    using_armor(Pelindung),nl.

utilize(X):-
    X == 3,!,
    write('Masukkan nama ramuan: '),nl,
    write('> '),
    read(Ramuan),
    using_potion(Ramuan),nl.

/* BAGIAN CHARACTER */
welcome_character_creation :-
    write('Welcome Adventure'),nl,
    write('Choose your Jobs!'),nl,
    write('1. Swordsman'),nl,
    write('2. Archer'),nl,
    write('3. Sorcerer'),nl,
    write('> '),
    read(X),
    /* BUAT KARAKTER */
    character_creation(X),
    char(Jobs,Level,Exp),
    /* TAMBAH ITEM DAN INVENTORY DASAR */
    item_weapon(1,Jobs,Weapon_Name,Kekuatan),
    item_armor(1,Armor_Name,Pertahanan),
    item_acc(1,Acc_Name,health),
    item_potion(Potion_Name,health),
    /* TAMBAH UANG DAN EQUIP ITEM DASAR */
    asserta(money(100)),
    asserta(weapon(Weapon_Name)),
    asserta(armor(Armor_Name)),
    asserta(acc(Acc_Name)),
    /* STATUS TAMBAHAN */
    character_bonus_stat_update,
    /* TAMBAH KE INVENTORY */
    asserta(inventory([])),
    inventory_add(Weapon_Name),
    inventory_add(Armor_Name),
    inventory_add(Acc_Name),
    inventory_add_N(Potion_Name,5).

/* PEMBUATAN CHARACTER */
character_creation(X) :-
    X == 1, !,
    write('You choose swordsman, lets explore the world'),nl,
    asserta(char(swordsman,1,0)),
    /* STATUS DASAR */
    asserta(attack(10,0)),
    asserta(defense(20,0)),
    asserta(max_HP(100)),
    asserta(health(100,0)).

character_creation(X) :-
    X == 2, !,
    write('You choose archer, lets explore the world'),nl,
    asserta(char(archer,1,0)),
    /* STATUS DASAR */
    asserta(attack(20,0)),
    asserta(defense(10,0)),
    asserta(max_HP(100)),
    asserta(health(100,0)).

character_creation(X) :-
    X == 3, !,
    write('You choose sorcerer, lets explore the world'),nl,
    asserta(char(sorcerer,1,0)),
    /* STATUS DASAR */
    asserta(attack(30,0)),
    asserta(defense(10,0)),
    asserta(max_HP(80)),
    asserta(health(80,0)).

/* char(Jobs,Level,Exp) */

/* MEKANISME LEVEL UP */
character_level_up :-
    /* PANGGIL VARIABEL CHARACTER */
    char(X,Y,Z),
    /* PERHITUNGAN LEVEL UP, EXP >= LEVEL*10 */
    Z >= Y*10, !,
    Yf is Y+1,
    Zf is Z-Y*10,
    /* UPDATE CHAR */
    retract(char(_,_,_)),
    asserta(char(X,Yf,Zf)),
    /* PERHITUNGAN STATUS BARU */
    attack(Att,BonusAtt),
    defense(Def,BonusDef),
    max_HP(MaxHP),
    health(Darah,BonusDarah),
    UP_Att is Att + Yf*10,
    UP_Def is Def + Yf*10,
    UP_MaxHP is MaxHP + Yf*50,
    UP_Darah is UP_MaxHP,
    /* UPDATE STATUS */
    retract(attack(_,_)),
    retract(defense(_,_)),
    retract(max_HP(_)),
    retract(health(_,_)),
    asserta(attack(UP_Att,BonusAtt)),
    asserta(defense(UP_Def,BonusDef)),
    asserta(max_HP(UP_MaxHP)),
    asserta(health(UP_Darah,BonusDarah)),
    /* Menampilkan Level UP */
    write('<---------------- Yeyyy, level UP dude!! ---------------->'),nl,
    DisplayAtt is Att+BonusAtt,
    DisplayDef is Def+BonusDef,
    DisplayHP is Darah+BonusDarah,
    DisplayNewAtt is UP_Att+BonusAtt,
    DisplayNewDef is UP_Def+BonusDef,
    DisplayNewHP is UP_Darah+BonusDarah,
    write('Health       = '), write(DisplayHP), write(' -> '), write(DisplayNewHP),nl,
    write('Attack       = '), write(DisplayAtt), write(' -> '), write(DisplayNewAtt),nl,
    write('Defense      = '), write(DisplayDef), write(' -> '), write(DisplayNewDef),nl,
    write('<------------------------------------------------------->'),nl.

character_level_up :-
    /* PANGGIL VARIABEL CHARACTER */
    char(X,Y,Z),
    /* PERHITUNGAN LEVEL UP, EXP >= LEVEL*10 */
    Z < Y*10, !.

/* BONUS STATUS */
character_bonus_stat_update :-
    /* PANGGIL ITEM YANG DIPAKAI, asumsi selalu ada item yang dipakai */
    weapon(Weapon_Name),
    armor(Armor_Name),
    acc(Acc_Name),
    /* Reset dulu jadi 0 */
    attack(Att,BonusAtt),
    defense(Def,BonusDef),
    health(HP,BonusHP),
    retract(attack(_,_)),
    retract(defense(_,_)),
    retract(health(_,_)),
    asserta(attack(Att,0)),
    asserta(defense(Def,0)),
    asserta(health(HP,0)),
    /* Hitung lagi bonusnya */
    character_bonus_stat_weapon(Weapon_Name),
    character_bonus_stat_armor(Armor_Name),
    character_bonus_stat_acc(Acc_Name),!.


character_bonus_stat_weapon(Weapon_Name) :-
    /* Panggil Item */
    item_weapon(_,_,Weapon_Name,Weapon_Att),
    /* Hitung Bonus */
    attack(Att,BonusAtt),
    New_BonusAtt is BonusAtt+Weapon_Att,
    retract(attack(_,_)),
    asserta(attack(Att,New_BonusAtt)),!.

character_bonus_stat_armor(Armor_Name) :-
    /* Panggil Item */
    item_armor(_,Armor_Name,Armor_Def),
    /* Hitung Bonus */
    defense(Def,BonusDef),
    New_BonusDef is BonusDef+Armor_Def,
    retract(defense(_,_)),
    asserta(defense(Def,New_BonusDef)),!.

character_bonus_stat_acc(Acc_Name) :-
    /* Panggil Item */
    item_acc(Lv,Acc_Name,Efek),
    /* Hitung Bonus */
    Efek == health,
    health(HP,BonusHP),
    New_BonusHP is BonusHP + Lv*4,
    retract(health(_,_)),
    asserta(health(HP,New_BonusHP)),!.

character_bonus_stat_acc(Acc_Name) :-
    /* Panggil Item */
    item_acc(Lv,Acc_Name,Efek),
    /* Hitung Bonus */
    Efek == attack,
    attack(Att,BonusAtt),
    New_BonusAtt is BonusAtt + Lv*4,
    retract(attack(_,_)),
    asserta(attack(Att,New_BonusAtt)),!.

character_bonus_stat_acc(Acc_Name) :-
    /* Panggil Item */
    item_acc(Lv,Acc_Name,Efek),
    /* Hitung Bonus */
    Efek == defense,
    defense(Def,BonusDef),
    New_BonusDef is BonusDef + Lv*4,
    retract(defense(_,_)),
    asserta(defense(Def,New_BonusDef)),!.


/* BAGIAN MAP */

/* Ukuran peta : 12x22 */
/* Peta terdefinisi dari 0..11 dan 0..21 */
/* Hanya bisa diakses dari 1..10 dan 1..20 */

/* Posisi NPC */
shop_pos(11,1).
quest_pos(3,1).

/* Menampilkan Peta */
map_show :-
    Y is 11,
    map_iterate_baris(Y). 

/* Iterasi Baris */
map_iterate_baris(-1) :-    /* Basis */
    !.
map_iterate_baris(Y) :-     /* Rekurens */
    X is 0,
    map_write_baris(X,Y),
    Next_Y is Y - 1,
    map_iterate_baris(Next_Y).

/* Menulis Baris */
map_write_baris(22,_) :-    /* Basis */
    write('\n'),!.
map_write_baris(X,Y) :-     /* Rekurens */
    map_write_element(X,Y),
    Next_X is X + 1,
    map_write_baris(Next_X,Y).

/* Menulis Setiap Elemen */
/* Menulis batas map */
map_write_element(_,0) :-   
    write('#'),!.
map_write_element(_,11) :-
    write('#'),!.
map_write_element(0,_) :-
    write('#'),!.
map_write_element(21,_) :-
    write('#'),!.
/* Menulis element pada map */
/* Player */
map_write_element(X,Y) :-
    player_pos(X,Y),
    write('P'),!.
/* Enemy */
map_write_element(X,Y) :-
    enemy_pos(X,Y,_),
    write('E'),!.
/* Shop */
map_write_element(X,Y) :-
    shop_pos(X,Y),
    write('S'),!.
/* Quest */
map_write_element(X,Y) :-
    quest_pos(X,Y),
    write('Q'),!.
/* Accessible Area */
map_write_element(X,Y) :-
    write('-'),!.


/* BAGIAN INVENTORY */

inventory_add(Item) :-
    inventory(Z),
    konso(Item,Z,NewList),
    retract(inventory(_)),
    asserta(inventory(NewList)).

inventory_add_N(Item,0) :- !.
inventory_add_N(Item,N) :- 
    N>0, 
    inventory_add(Item),  
    S is N-1, 
    inventory_add_N(Item,S).

inventory_del(Item) :-
    inventory(Z),
    delElmt(Item,Z,Zf),
    retract(inventory(_)),
    asserta(inventory(Zf)).
    
isi_inventory :-
    write("Your inventory: "),nl,
    inventory(Inv),
    writeList(Inv).
    
    
/* BAGIAN ITEM */
/* MEKANISME MEMAKAI ITEM DARI INVENTORY (WEAPON,ARMOR,ACC) */
/* misal kita swordsman,*/



using_weapon(X) :-
    /* X adalah nama weapon, JobsW adalah jenis jobs yang sesuai dengan weapon, Z adalah inventory */
    inventory(Z),
    isMember(X,Z), !,
    char(Jobs,_,_),
    item_weapon(_,JobsW,X,_),
    Jobs = JobsW,
    retract(weapon(_)),
    asserta(weapon(X)),
    write('Anda menggunakan senjata '), write(X), nl,
    character_bonus_stat_update.
    


using_armor(X) :-
    inventory(Z),
    isMember(X,Z),
    retract(armor(_)),
    asserta(armor(X)),
    character_bonus_stat_update.

/* MEKANISME MEMAKAI POTION */
using_potion(X) :-
    inventory(Z),
    isMember(X, Z),
    item_potion(X, ItemOption),
    ItemOption == health, !,
    health(CurrentHp, CurrentBonusHp),
    CurrentBonusHpTemp is CurrentBonusHp + 1,
    Temporary is CurrentHp,
    max_HP(Hp),
    retract(health(_, _)),
    asserta(health(Hp, CurrentBonusHpTemp)),
    inventory_del(X).

using_potion(X) :-
    inventory(Z),
    isMember(X, Z),
    item_potion(X, ItemOption),
    ItemOption == attack, !,
    attack(CurrentAtt, CurrentBonusAtt),
    CurrentBonusAttTemp is CurrentBonusAtt + 1,
    Temporary is CurrentAtt,
    retract(attack(_, _)),
    asserta(attack(Temporary, CurrentBonusAttTemp)),
    inventory_del(X).    

using_potion(X) :-
    inventory(Z),
    isMember(X, Z),
    item_potion(X, ItemOption),
    ItemOption == defense, !,
    defense(CurrDef, BonusCurrDef),
    BonusCurrDefTemp is BonusCurrDef + 1,
    Temporary is CurrDef,
    retract(defense(_,_)),
    asserta(defense(Temporary, BonusCurrDefTemp)).
    inventory_del(X).

/* BAGIAN ENEMY */


random_enemy :-
    random(1, 3, Enemy_1_X),
    random(2, 5, Enemy_1_Y),
    random(4, 6, Enemy_2_X),
    random(3, 4, Enemy_2_Y),
    random(7, 9, Enemy_3_X),
    random(5, 6, Enemy_3_Y),
    random(10, 12, Enemy_4_X),
    random(7, 8, Enemy_4_Y),
    random(13, 15, Enemy_5_X),
    random(9, 10, Enemy_5_Y),
    random(16, 18, Enemy_6_X),
    random(1, 2, Enemy_6_Y),
    random(19, 20, Enemy_7_X),
    random(3, 4, Enemy_7_Y),
    random(1, 5, Enemy_8_X),
    random(5, 6, Enemy_8_Y),
    random(6, 9, Enemy_9_X),
    random(7, 8, Enemy_9_Y),
    random(1, 11, Enemy_10_X),
    random(7, 10, Enemy_10_Y),

    /*retract(enemy_pos(_,_,_)),*/

    asserta(enemy_pos(Enemy_1_X,Enemy_1_Y, 1)),
    asserta(enemy_pos(Enemy_2_X,Enemy_2_Y, 2)),
    asserta(enemy_pos(Enemy_3_X,Enemy_3_Y, 3)),
    asserta(enemy_pos(Enemy_4_X,Enemy_4_Y, 1)),
    asserta(enemy_pos(Enemy_5_X,Enemy_5_Y, 1)),
    asserta(enemy_pos(Enemy_6_X,Enemy_6_Y, 2)),
    asserta(enemy_pos(Enemy_7_X,Enemy_7_Y, 2)),
    asserta(enemy_pos(Enemy_8_X,Enemy_8_Y, 2)),
    asserta(enemy_pos(Enemy_9_X,Enemy_9_Y, 2)),
    asserta(enemy_pos(Enemy_10_X,Enemy_10_Y, 4)),!.
    

/* BAGIAN QUEST */
quest_tier(1, 2, 1, 0, 0).
quest_tier(2, 1, 2, 0, 0).
quest_tier(3, 0, 2, 1, 0).
quest_tier(4, 0, 0, 0, 1).

/* quest_tier(Lv_Quest,Kill_Slime,Kill_Goblin,Kill_Wolf,Kill_Sauron) */


/* Pertama kali kita datang ke quest (Q), kita diberikan quest tier 1 */
quest_init :-
    quest_tier(1, Quest_Kill_Slime, Quest_Kill_Goblin, Quest_Kill_Wolf, Quest_Kill_Sauron),
    
    asserta(quest(1, Quest_Kill_Slime, Quest_Kill_Goblin, Quest_Kill_Wolf, Quest_Kill_Sauron)),
    
    retract(kill_count(_,_,_,_)),
    asserta(kill_count(0, 0, 0, 0)).

quest_check :-
    quest(Current_Quest_Level, Current_Quest_Kill_Slime, Current_Quest_Kill_Goblin, Current_Quest_Kill_Wolf, Current_Quest_Kill_Sauron),
    
    Current_Quest_Level < 4,
    
    kill_count(Current_Kill_Slime, Current_Kill_Goblin, Current_Kill_Wolf, Current_Kill_Sauron),
    
    Current_Quest_Kill_Slime =< Current_Kill_Slime,
    Current_Quest_Kill_Goblin =< Current_Kill_Goblin,
    Current_Quest_Kill_Wolf =< Current_Kill_Wolf,
    Current_Quest_Kill_Sauron =< Current_Kill_Sauron,

    /* Reset Kill Count */
    Current_Kill_Slime_New is Current_Kill_Slime - Current_Quest_Kill_Slime,
    Current_Kill_Goblin_New is Current_Kill_Goblin - Current_Quest_Kill_Goblin,
    Current_Kill_Wolf_New is Current_Kill_Wolf - Current_Quest_Kill_Wolf,
    Current_Kill_Sauron_New is Current_Kill_Sauron - Current_Quest_Kill_Sauron,

    write('You have completed the quest! Lets continue our journey! '),nl,
    retract(kill_count(_, _, _, _)),
    asserta(kill_count(Current_Kill_Slime_New, Current_Kill_Goblin_New, Current_Kill_Wolf_New, Current_Kill_Sauron_New)),
    
    char(Current_Job, Current_Level, Current_Exp),
    New_Exp is Current_Exp + (Current_Quest_Level * 100),
    retract(char(_, _, _)),
    asserta(char(Current_Job, Current_Level, New_Exp)).

quest_check :-
    quest(Current_Quest_Level, Current_Quest_Kill_Slime, Current_Quest_Kill_Goblin, Current_Quest_Kill_Wolf, Current_Quest_Kill_Sauron),
    
    Current_Quest_Level == 4,
    
    kill_count(Current_Kill_Slime, Current_Kill_Goblin, Current_Kill_Wolf, Current_Kill_Sauron),

    Current_Kill_Sauron == Current_Quest_Kill_Sauron,

    retract(kill_Boss_Status(_)),
    asserta(kill_Boss_Status(1)).
    
/* Gunakan dynamic predicate quest dan kill_count */

/* Update quest yang sedang aktif */

/* Cek apakah misi berhasil (quest==killcount)*/
    /* Kalau berhasil, kasih gold+exp */
    
/* BAGIAN EXPLORATION MECHANISM */

/* Player Movement */

/* Is Accessible */
isAccessible(X,Y) :- 
    X>=1, X=<20, Y>=1, Y=<10,
    \+enemy_pos(X,Y,_),
    \+shop_pos(X,Y),
    \+quest_pos(X,Y).

gerak(w) :-
    player_pos(Xi,Yi),
    Yf is Yi + 1,
    Xf is Xi,
    isAccessible(Xf,Yf), !,
    retract(player_pos(_,_)),
    asserta(player_pos(Xf,Yf)).

gerak(w) :-
    write('Kamu tidak bisa bergerak kesana!'), !.

gerak(a) :-
    player_pos(Xi,Yi),
    Yf is Yi,
    Xf is Xi - 1,
    isAccessible(Xf,Yf), !,
    retract(player_pos(_,_)),
    asserta(player_pos(Xf,Yf)).

gerak(a) :-
    write('Kamu tidak bisa bergerak kesana!'), !.

gerak(s) :-
    player_pos(Xi,Yi),
    Yf is Yi - 1,
    Xf is Xi, !,
    isAccessible(Xf,Yf),
    retract(player_pos(_,_)),
    asserta(player_pos(Xf,Yf)).

gerak(s) :-
    write('Kamu tidak bisa bergerak kesana!'), !.

gerak(d) :-
    player_pos(Xi,Yi),
    Yf is Yi,
    Xf is Xi + 1,
    isAccessible(Xf,Yf), !,
    retract(player_pos(_,_)),
    asserta(player_pos(Xf,Yf)).

gerak(d) :-
    write('Kamu tidak bisa bergerak kesana!'), !.

/* BAGIAN TELEPORT */
teleport:-
    write('Masukkan titik X :'),nl,
    write('> '),
    read(X),nl,
    write('Masukkan titik Y :'),nl,
    write('>'),
    read(Y),nl,
    isAccessible(X,Y),!,
    retract(player_pos(_,_)),
    asserta(player_pos(X,Y)).

teleport:-
    write('Kamu tidak bisa bergerak kesana!'), !.

/* Mengecek apakah ada sesuatu yang dekat dengan kita */
/* enemy */
is_enemy_near(Lv_Enemy,X_Enemy,Y_Enemy) :-  
/* kalo enemy ada di kiri player*/
    player_pos(X_Player, Y_Player),
    X_Enemy is X_Player + 1,
    Y_Enemy is Y_Player,
    enemy_pos(X_Enemy, Y_Enemy,Lv_Enemy),!.

is_enemy_near(Lv_Enemy,X_Enemy,Y_Enemy) :-
/* kalo enemy ada di kanan player*/
    player_pos(X_Player, Y_Player),
    X_Enemy is X_Player - 1,
    Y_Enemy is Y_Player,
    enemy_pos(X_Enemy, Y_Enemy,Lv_Enemy),!.

is_enemy_near(Lv_Enemy,X_Enemy,Y_Enemy) :-
/* kalo enemy ada di bawah player*/
    player_pos(X_Player, Y_Player),
    X_Enemy is X_Player,
    Y_Enemy is Y_Player + 1,
    enemy_pos(X_Enemy, Y_Enemy,Lv_Enemy),!.

is_enemy_near(Lv_Enemy,X_Enemy,Y_Enemy) :-
/* kalo enemy ada di atas player*/
    player_pos(X_Player, Y_Player),
    X_Enemy is X_Player,
    Y_Enemy is Y_Player - 1,
    enemy_pos(X_Enemy, Y_Enemy,Lv_Enemy),!.

/* quest */
is_quest_near :-
    player_pos(X_Player, Y_Player),
    X_Quest is X_Player + 1,
    Y_Quest is Y_Player,
    quest_pos(X_Quest, Y_Quest),!.

is_quest_near :-
    player_pos(X_Player, Y_Player),
    X_Quest is X_Player - 1,
    Y_Quest is Y_Player,
    quest_pos(X_Quest, Y_Quest),!.

is_quest_near :-
    player_pos(X_Player, Y_Player),
    X_Quest is X_Player,
    Y_Quest is Y_Player + 1,
    quest_pos(X_Quest, Y_Quest),!.

is_quest_near :-
    player_pos(X_Player, Y_Player),
    X_Quest is X_Player,
    Y_Quest is Y_Player - 1,
    quest_pos(X_Quest, Y_Quest),!.

/* shop */
is_shop_near :-
    player_pos(X_Player, Y_Player),
    X_Shop is X_Player + 1,
    Y_Shop is Y_Player,
    shop_pos(X_Shop, Y_Shop),!.

is_shop_near :-
    player_pos(X_Player, Y_Player),
    X_Shop is X_Player - 1,
    Y_Shop is Y_Player,
    shop_pos(X_Shop, Y_Shop),!.

is_shop_near :-
    player_pos(X_Player, Y_Player),
    X_Shop is X_Player,
    Y_Shop is Y_Player - 1,
    shop_pos(X_Shop, Y_Shop),!.

is_shop_near :-
    player_pos(X_Player, Y_Player),
    X_Shop is X_Player,
    Y_Shop is Y_Player + 1,
    shop_pos(X_Shop, Y_Shop),!.

quest_open :-

    quest(Current_Quest_Level, Current_Kill_Slime, Current_Kill_Goblin, Current_Kill_Wolf, Current_Kill_Sauron),
    write('Your current quest level : '), write(Current_Quest_Level),nl,
    Current_Quest_Level < 4,
    write('Task'),nl,
    write('1. Kill Slime   :'), write(Current_Kill_Slime),nl,
    write('2. Kill Goblin  :'), write(Current_Kill_Goblin),nl,
    write('3. Kill Wolf    :'), write(Current_Kill_Wolf),nl.
    
quest_open :-
    quest(Current_Quest_Level, Current_Kill_Slime, Current_Kill_Goblin, Current_Kill_Wolf, Current_Kill_Sauron),
    write('Your current quest level : '), write(Current_Quest_Level),nl,
    Current_Quest_Level == 4,
    write('Task'),
    write('1. Kill Boss (Sauron)   :'), write(Current_Kill_Sauron),nl.

/* Buka quest */
quest :-
    is_quest_near, !,
    quest_open.

quest :-
    \+ is_quest_near, !,
    write('Tidak ada tempat quest disekitarmu!').

/* Buka shop */
shop :-
    is_shop_near, !,
    store.

shop :-
    \+ is_shop_near, !,
    write('Tidak ada tempat store disekitarmu!').

/* Enemy info */
/*
enemy_info(Level) :-
    enemy_type(Level,Nama,Att,Def,Health),
    write('Kind     = '), write(Nama),nl,
    write('Attack   = '), write(Att),nl,
    write('Defense  = '), write(Def),nl,
    write('Health   = '), write(Health),nl.
*/

/* Ajak berantem musuh */
info_enemy :-
    is_enemy_near(Lv_Enemy,_,_),
    enemy_type(Lv_Enemy,Nama_Enemy,_,_,_),
    write('Ohh no, '),write(Nama_Enemy),write(' musuh menghampirimu!!!'),nl,!, 
    serang.

info_enemy :-
    \+is_enemy_near(Lv_Enemy,_,_),
    write('Tidak ada musuh disekitarmu!'),nl,!.


/* BAGIAN BATTLE MECHANISM */
/* gunakan dynamic predicate turn/1 dan current_enemy/4 */
/* enemy_type(lv,kind,attack,defense,health)*/


serang :-
    is_enemy_near(Lv_Enemy,X_Enemy,Y_Enemy),
    enemy_type(Lv_Enemy,Kind_Enemy,Att_Enemy,Def_Enemy,HP_Enemy),
    asserta(current_enemy(HP_Enemy,Lv_Enemy,X_Enemy,Y_Enemy)),
    asserta(turn(0)),
    serang_musuh.
    
serang_musuh :-
    gameOn(1),
    info_current_battle,
    write('Do something!    (serang/serangan_maut/buka_inventory/lari)'),nl,
    write('> '),
    read(X), !,
    serang_action(X),
   /* X \= lari, */
    turn(N),
    N1 is N + 1,
    retract(turn(_)),
    asserta(turn(N1)),
    serang_player.
    
/* enemy_type(lv,kind,attack,defense,health)*/

info_current_battle :-
    current_enemy(HP_Enemy,Lv_Enemy,_,_),
    enemy_type(Lv_Enemy,Enemy_Kind,Enemy_Att,Enemy_Def,_),
    char(Jobs,_,_),
    attack(Att,BonusAtt),
    defense(Def,BonusDef),
    health(HP,BonusHP),
    DisplayAtt is Att+BonusAtt,
    DisplayDef is Def+BonusDef,
    DisplayHP is HP+BonusHP,
    write('<------------------ BATTLE INFO ------------------> '),nl,
    write(' Player Jobs : '), write(Jobs), nl,
    write(' Player HP   : '), write(DisplayHP), nl,
    write(' Player Att  : '), write(DisplayAtt), nl,
    write(' Player Def  : '), write(DisplayDef), nl,
    write(' -------------------------------------------------'),nl,
    write(' Enemy Type  : '), write(Enemy_Kind), nl,
    write(' Enemy HP    : '), write(HP_Enemy), nl,
    write(' Enemy Att   : '), write(Enemy_Att), nl,
    write(' Enemy Def   : '), write(Enemy_Def), nl,
    write('<------------------------------------------------->'),nl.

/* Action yang bisa dilakukan ketika ketemu musuh */
serang_action(X):-
    X == serang, !,
    /* Kasih tulisan berapa damage yang dikasih ke enemy */
    attack(Att_Player,Bonus_Att_Player),
    current_enemy(Hp_Enemy,Lv,_,_),
    enemy_type(Lv,Kind,_,Enemy_Def,_),
    /* Deal Damage */
    damage_calculator(Att_Player,Bonus_Att_Player,Enemy_Def,0, Damage),
    write('You deal '),write(Damage),write(' damage'),nl,
    New_Hp_Enemy is Hp_Enemy - Damage,
    enemy_status(New_Hp_Enemy).

serang_action(X) :-
    X == serangan_maut,
    turn(N),
    N >= 3, !,
    /* sama kayak X == serang, cuma beda damage doang, setelah 3 kali serangan normal */
    attack(Att_Player,Bonus_Att_Player),
    current_enemy(Hp_Enemy,Lv,_,_),
    enemy_type(Lv,Kind,_,Enemy_Def,_),
    New_Att_Player is 2*Att_Player,
    /* Deal Damage */
    damage_calculator(New_Att_Player,Bonus_Att_Player,Enemy_Def,0, Damage),
    /* Kasih tulisan berapa damage yang dikasih ke enemy */
    write('You deal '),write(Damage),write(' damage'),nl,
    New_Hp_Enemy is Hp_Enemy - Damage,
    retract(turn(_)),
    asserta(turn(0)),
    enemy_status(New_Hp_Enemy).

serang_action(X) :-
    X == serangan_maut,
    turn(N),
    N < 3, !,
    write('Serangan maut gagal!'),nl.

serang_action(X):-
    X == lari, !,
    lariyee.

serang_action(X):-
    X == buka_inventory, !,
    open_inventory.

enemy_status(HP) :-
    HP > 0, !,
    update_darah_musuh(HP).
    
enemy_status(HP) :-
    HP =< 0, !,
    /* Nambah EXP dan uang */
    char(Jobs,Lv,Xp),
    current_enemy(_,Lv_Enemy,X,Y),

    tambah_kill_count(Lv_Enemy),

    NXp is Xp+Lv_Enemy*5,
    retract(char(_,_,_)),
    asserta(char(Jobs,Lv,NXp)),

    write('Hore!! Musuh berhasil terkalahkan!'),nl,
    character_level_up,
    
    money(Uang),
    Nuang is Uang + Lv_Enemy*100,
    retract(money(_)),
    asserta(money(Nuang)),
    
    /* Hapus enemy di posisi itu, retract enemy_pos, dan retract turn */
    retract(current_enemy(_,_,_,_)),
    retract(enemy_pos(X,Y,Lv_Enemy)),
    retract(turn(_)),
    fail,!.
    
tambah_kill_count(Lv_Enemy):-
    kill_count(Slime,Goblin,Wolf,Sauron),
    Lv_Enemy == 1,
    new_Kill is slime+1,
    retract(kill_count(_,_,_,_)),
    asserta(kill_count(new_Kill,goblin,wolf)),!.
    
tambah_kill_count(Lv_Enemy):-
    kill_count(Slime,Goblin,Wolf),
    Lv_Enemy == 2,
    New_Kill is Goblin+1,
    retract(kill_count(_,_,_)),
    asserta(kill_count(Slime,New_Kill,Wolf)),!.

tambah_kill_count(Lv_Enemy):-
    kill_count(Slime,Goblin,Wolf),
    Lv_Enemy == 3,
    New_Kill is wolf+1,
    retract(kill_count(_,_,_)),
    asserta(kill_count(Slime,Goblin,New_Kill)),!.

tambah_kill_count(Lv_Enemy):-
    kill_Boss_Status(X),
    Lv_Enemy == 4,
    retract(kill_Boss_Status(_)),
    asserta(kill_Boss_Status(1)),!.

/*
serang_action_inventory(X):-
    using_potion(X),
    write('Potion berhasil digunakan.'),nl.
*/

lariyee :-
    random(1,4,Probability),
    Probability \= 4, !,
    retract(turn(_)),
    write('Kamu berhasil lari!'),nl,
    retract(current_enemy(_,_,_,_)),!,fail. /*cut_fail*/
    
lariyee :-
    random(1,4,Probability),
    Probability == 4, !,
    write('Tidak! Kamu gagal kabur!!!'),nl,!. 

serang_player:-
    health(Darah,BonusDarah),
    defense(Def,BonusDef),
    current_enemy(HP_Enemy,Lv_Enemy,_,_),
    enemy_type(Lv_Enemy,Kind_Enemy,Att_Enemy,Def_Enemy,Hp_Enemy),
    /* ini bug character jadi immortal */
    damage_calculator(Att_Enemy,0,Def,BonusDef, Damage),
    /* harusnya bonus darah dulu yang dikurangin */
    Result is BonusDarah - Damage, 
    health_damage(Result,Damage),
    write('Enemy deal '),write(Damage),write(' damage'),nl,
    health(HP,_),
    player_status(HP),
    serang_musuh.

player_status(HP) :-
    HP > 0, !.

player_status(HP) :-
    HP =< 0, !,
    write(' </3  MODAR KOE!!  </3 '),nl,
    write('<---- GAME OVER ----->'),nl,
    retract(gameOn(_)),
    asserta(gameOn(0)),!.


health_damage(Result,Damage):-
    health(Darah,BonusDarah),
    Result > 0,
    retract(health(_,_)),
    asserta(health(Darah,Result)),!.

health_damage(Result,Damage):-
    health(Darah,BonusDarah),
    Result =< 0,
    Result is Darah + BonusDarah - Damage,
    retract(health(_,_)),
    asserta(health(Result,0)),!.

damage_calculator(Att,BonusAtt,Def,BonusDef,Damage) :-
    Total is Att+BonusAtt-Def-BonusDef,
    Total >= 0,
    Damage is Total,!.

damage_calculator(Att,BonusAtt,Def,BonusDef,Damage) :-
    Total is Att+BonusAtt-Def-BonusDef,
    Total < 0,
    Damage is 0,!.

update_darah_musuh(HP_Enemy) :-
    retract(current_enemy(_,Lv,X,Y)),
    asserta(current_enemy(HP_Enemy,Lv,X,Y)). 

/* BAGIAN STORE */


store :-
    write('___________________________________'),nl,
    write('  _____ _______ ____  _____  ______'),nl,
    write(' / ____|__   __/ __  |  __  |  ____|'),nl,
    write('| (___    | | | |  | | |__) | |__'),nl,
    write('  ___     | | | |  | |  _  /|  __|'),nl,
    write(' ____) |  | | | |__| | | |  | |____'),nl,
    write('|_____/   |_|   ____/|_| | _|______|'),nl,
    write('_________________________ ____________'),nl,
    write('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'),nl,
    write('%    Choose what you want to buy    %'),nl,
    write('%                                   %'),nl,
    write('%  1. Swordsman Weapon (20 Money)   %'),nl,
    write('%  2. Archer Weapon (20 Money)      %'),nl,
    write('%  3. Sorcerer Weapon (20 Money)    %'),nl,
    write('%  4. Armor (20 Money)              %'),nl,
    write('%  5. Accesories (20 Money)         %'),nl,
    write('%  6. Potion (20 Money/5 potion)    %'),nl,
    write('%  7. Quit                          %'),nl,
    write('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'),nl,
    money(Uang),
    write('Your money :'),write(Uang),nl,
    write('> '),
    read(X),
    X >= 1, X < 7, !,
    New_Uang is Uang - 20,
    uang_cukup(New_Uang),
    
    store_item_handling(X),
    retract(money(_)),
    asserta(money(New_Uang)).

uang_cukup(Uang):-
    Uang >= 0, !.

uang_cukup(Uang):-
    Uang < 0,!,
    write('Uang kamu tidak cukup!'),nl,fail.
    
store_item_handling(X) :-
    X == 1,
    write('You choose Swordsman Weapon'),nl,
    /* Randomize dan masukan ke Inventory */
    random(1, 3, Hasil_Gacha),
    random_item_swordsman(Hasil_Gacha).
    
store_item_handling(X) :-
    X == 2,
    write('You choose Archer Weapon'),nl,
    /* Randomize dan masukan ke Inventory */
    random(1, 3, Hasil_Gacha),
    random_item_archer(Hasil_Gacha).

store_item_handling(X) :-
    X == 3,
    write('You choose Sorcerer Weapon'),nl,
    /* Randomize dan masukan ke Inventory */
    random(1, 3, Hasil_Gacha),
    random_item_sorcerer(Hasil_Gacha).

store_item_handling(X) :-
    X == 4,
    write('You choose Armor'),nl,
    /* Randomize dan masukan ke Inventory */
    random(1, 3, Hasil_Gacha),
    random_item_armor(Hasil_Gacha).

store_item_handling(X) :-
    X == 5,
    write('You choose Accessories'),nl,
    /* Randomize dan masukan ke Inventory */
    random(1, 6, Hasil_Gacha),
    random_item_accesories(Hasil_Gacha).

store_item_handling(X) :-
    X == 6,
    write('Choose your Potion'),nl,
    write('1. Freshcare (health)'),nl,
    write('2. Bodrex (attack)'),nl,
    write('3. Antangin (defense)'),nl,
    /* Potion tidak randomize langsung beli aja mang */
    write('> '),
    read(Y),
    add_item_potion(Y).
    
random_item_swordsman(Hasil_Gacha) :-
    Hasil_Gacha == 1,!,
    write('You get Wooden Sword'),nl,
    inventory_add(wooden_sword).
    
random_item_swordsman(Hasil_Gacha) :-
    Hasil_Gacha == 2,!,
    write('You get Iron Sword'),nl,
    inventory_add(iron_sword).
    
random_item_swordsman(Hasil_Gacha) :-
    Hasil_Gacha == 3,!,
    write('You get Diamond Sword'),nl,
    inventory_add(diamond_sword).

random_item_archer :-
    Hasil_Gacha == 1,!,
    write('You get Wooden Bow'),nl,
    inventory_add(wooden_bow).

random_item_archer :-
    Hasil_Gacha == 2,!,
    write('You get Iron Bow'),nl,
    inventory_add(iron_bow).

random_item_archer :-
    Hasil_Gacha == 3,!,
    write('You get Diamond Bow'),nl,
    inventory_add(diamond_bow).

random_item_sorcerer :-
    Hasil_Gacha == 1,!,
    write('You get Wooden Staff'),nl,
    inventory_add(wooden_staff).

random_item_sorcerer :-
    Hasil_Gacha == 2,!,
    write('You get Iron Staff'),nl,
    inventory_add(iron_staff).

random_item_sorcerer :-
    Hasil_Gacha == 3,!,
    write('You get Diamond Staff'),nl,
    inventory_add(diamond_staff).

random_item_armor(Hasil_Gacha) :-
    Hasil_Gacha == 1,!,
    write('You get Security Vest'),nl,
    inventory_add(security_vest).
    
random_item_armor(Hasil_Gacha) :-
    Hasil_Gacha == 2,!,
    write('You get Police Vest'),nl,
    inventory_add(police_vest).

random_item_armor(Hasil_Gacha) :-
    Hasil_Gacha == 3,!,
    write('You get Military Vest'),nl,
    inventory_add(military_vest).
    
random_item_accesories(Hasil_Gacha) :-
    Hasil_Gacha == 1,!,
    write('You get Batu Akik Accesories'),nl,
    inventory_add(batu_akik).

random_item_accesories(Hasil_Gacha) :-
    Hasil_Gacha == 2,!,
    write('You get Anting Jamet Accesories'),nl,
    inventory_add(anting_jamet).

random_item_accesories(Hasil_Gacha) :-
    Hasil_Gacha == 3,!,
    write('You get Topi Pramuka Accesories'),nl,
    inventory_add(topi_pramuka).

random_item_accesories(Hasil_Gacha) :-
    Hasil_Gacha == 4,!,
    write('You get Kalung Corona Accesories'),nl,
    inventory_add(kalung_corona).

random_item_accesories(Hasil_Gacha) :-
    Hasil_Gacha == 5,!,
    write('You get Power Balance Accesories'),nl,
    inventory_add(powerbalance).

random_item_accesories(Hasil_Gacha) :-
    Hasil_Gacha == 6,!,
    write('You get Masker Accesories'),nl,
    inventory_add(masker).

add_item_potion(Y) :-
    Y == 1,!,
    write('You get 5 freshcare potion'),nl,
    inventory_add_N(freshcare,5).

add_item_potion(Y) :-
    Y == 2,!,
    write('You get 5 bodrex potion'),nl,
    inventory_add_N(bodrex,5).

add_item_potion(Y) :-
    Y == 3,!,
    write('You get 5 antangin potion'),nl,
    inventory_add_N(antangin,5).
    
    
/* Display New Game*/
start :-
    /*Insialisasi program*/
    write('WELCOME !!'),nl,
    write('Lets play and be a progammer'),nl,
    write(''),nl,
    
    write('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'),nl,
    write('%                        ~Genshin Sekai~                         %'),nl,
    write('%                                                                %'),nl,
    write('%                  "HIDUP KEMBALI DI DUNIA WIBU"                 %'),nl,
    write('%                                                                %'),nl,
    write('%  CREDIT :                                                      %'),nl,
    write('%        1. Muhammad Azhar Faturahman (13519020)                 %'),nl,
    write('%        2. Daru Bagus Dananjaya      (13519080)                 %'),nl,
    write('%        3. Karel Renaldi             (13519180)                 %'),nl,
    write('%        4. Rayhan Asadel             (13519196)                 %'),nl,
    write('%        5. Muhammad Dehan Al Kautsar (13519200)                 %'),nl,
    write('%                                                                %'),nl,
    write('%                                                                %'),nl,
    write('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'),nl,
    /*restart,*/
    asserta(player_pos(1,1)),
    asserta(kill_count(0,0,0,0))
    welcome_character_creation,
    random_enemy,
    quest_init,
    asserta(killBoss(0)),
    asserta(gameOn(1)),
    help,
    game_cond.
    
        

    
/*restart:-  
    retract(gameOn(_)),
    retract(killBoss(_)),
    retract(char(_,_,_)),
    retract(attack(_,_)),
    retract(defense(_,_)),
    retract(max_HP(_)),
    retract(health(_,_)),
    retract(weapon(_)),
    retract(armor(_)),
    retract(acc(_)),
    retract(inventory(_)),
    retract(money(_)),
    retract(player_pos(_,_)),
    retract(enemy_pos(_,_,_)),
    retract(quest(_,_,_)),
    retract(kill_count(_,_,_)),
    asserta(gameOn(0)),
    asserta(killBoss(0)).*/

/* Tampilan Help */
help :- write('_________________________________________________________________________________________'),nl,
        write('________________________________________________________________'),nl,
        write('________________________________________________________________'),nl,
        write('/ ____|               | |   (_)        / ____|    | |       (_)'), nl,
        write('| |  __  ___ _ __  ___| |__  _ _ __   | (___   ___| | _________'),nl,
        write('| | |_ |/ _    _  / __|  _  | |  _      ___   / _   |/ / _` | |'),nl,
        write('| |__| |  __/ | |  __   | | | | | | |  ____) |  __/   < (_| | |'),nl,
        write(' ______| ___|_| |_|___/_| |_|_|_| |_| |_____/  ___|_| _ __,_|_|'),nl,
        write('_______________________________________________________________'),nl,

        write('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'),nl,
        write('%                        ~Genshin Sekai~                             %'),nl,
        write('%                                                                    %'),nl,
        write('%  1. map        : menampilkan peta                                  %'),nl,
        write('%  2. status     : menampilkan kondisimu terkini                     %'),nl,
        write('%  3. w          : gerak ke utara 1 langkah                          %'),nl,
        write('%  4. s          : gerak ke selatan 1 langkah                        %'),nl,
        write('%  5. d          : gerak ke ke timur 1 langkah                       %'),nl,
        write('%  6. a          : gerak ke barat 1 langkah                          %'),nl,
        write('%  7. help       : menampilkan segala bantuan                        %'),nl,
        write('%  8. attack     : menyerang musuh                                   %'),nl,
        write('%  9. store      : masuk ke dalam toko                               %'),nl,
        write('% 10. quest      : mengecek current quest                            %'),nl,
        write('% 11. teleport   : pindah ke titik sesuka hati                       %'),nl,
        write('% 12. inventory  : menampilkan inventory                             %'),nl,
        write('% 11. quit       : cabut                                             %'),nl,
        write('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'),nl,
        write(''),nl,
        write('Legends:'),nl,
        write('P = Player'),nl,
        write('S = Store'),nl,
        write('F = Hangar'),nl,
        write('E = Enemy'),nl,
        write('D = Boss Enemy'),nl,
        write('Q = Quest'),nl,
        write('# = Inaccessible Path'),nl,
        write('- = Accessible Path'),nl,

        write('__________________________________________________________________________________________'),nl.
        