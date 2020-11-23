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
   weapon/1, armor/1, acc/1, inventory/1, money/1, enemy_att/2,
   player_pos/2, enemy_pos/3).
/* char(Jobs,Level,Exp), attack(Att,BonusAtt), defense(Def,BonusDef), max_HP(Darah_Maksimal),  
 * health(Darah,BonusDarah), weapon(Senjata), armor(Armor), acc(Aksesoris),
 * inventory(List), enemy_att(NamaMusuh,Attack), player_pos(X,Y), enemy_pos(X,Y,kind) */
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
/* Menyatakan stauts keberlangsungan game, */
/* gameOn(1) : permainan berjalan, player masih hidup */
/* gameOn(0) : permainan berakhir, player terbunuh, atau permainan belum dimulai */
gameOn(0).


/* ENEMY */
enemy_common(slime).
enemy_common(goblin).
enemy_common(wolf).
enemy_boss(sauron).

/* ITEM */
/* item_weapon(tingkat senjata, char_jobs, char_weapon, kekuatan) */

/* Item Jobs Swordsman */
item_weapon(1,swordsman,wooden_sword,10).
item_weapon(2,swordsman,iron_sword,20).
item_weapon(3,swordsman,diamond_sword,30).

/* Item Jobs Archer */
item_weapon(1,archer,wooden_bow,10).
item_weapon(2,archer,iron_bow,20).
item_weapon(3,archer,diamond_bow,30).

/* Item Jobs Sorcerer */
item_weapon(1,sorcerer,wooden_staff,10).
item_weapon(2,sorcerer,iron_staff,20).
item_weapon(3,sorcerer,diamond_staff,30).

/* Armor */
/* item_armor(tingkat pelindung, char_armor, defense) */
item_armor(1,security_vest,10).
item_armor(2,police_vest,20).
item_armor(3,military_vest,30).

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

/* Game Looping */
game_cond :-
    gameOn(1),
    repeat,
        read(command),
        run(command),
        (cekmenang)
        /* perulangan game*/

/* Basic rules */
/* Fungsi-Fungsi Dasar */
isAccessible(X,Y) :- X>=1, X<=20, Y>=1, Y<=10.

writeList([]):- nl.
writeln([H|T]):-
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
    X <> Y,
    isMember(X,Xs).


/* Ukuran peta : 12x22 */
/* Peta terdefinisi dari 0..11 dan 0..21 */
/* Hanya bisa diakses dari 1..10 dan 1..20 */
/* Player Movement */
gerak(Xi,Yi,w,Xf,Yf) :-
    gameOn(1),
    Yi < 10,
    Yf is Yi + 1,
    Xf is Xi, !.
gerak(Xi,Yi,a,Xf,Yf) :-
    gameOn(1),
    Xi > 1,
    Xf is Xi - 1,
    Yf is Yi, !.
gerak(Xi,Yi,s,Xf,Yf) :-
    gameOn(1),
    Yi > 1,
    Yf is Yi + 1,
    Xf is Xi, !.
gerak(Xi,Yi,d,Xf,Yf) :-
    gameOn(1),
    Xi < 20,
    Xf is Xi + 1,
    Yf is Yi, !.    

/* STATUS */
status :- 
    gameOn(1),
    attack(Att,BonusAtt),
    defense(Def,BonusDef),
    inventory(Inv),
    health(Hp,BonusHp),
    DisplayAtt is Att+BonusAtt,
    DisplayDef is Def+BonusDef,
    DisplayHP is Hp+BonusHp,
    write('Health       = '), writeln(DisplayHP),
    write('Attack       = '), writeln(DisplayAtt),
    write('Defense      = '), writeln(DisplayDef),
    write('Inventory    = '), writeList(Inv).
            

/* BAGIAN CHARACTER */
welcome_character_creation :-
    writeln('Welcome Adventure'),
    writeln('Choose your Jobs!'),
    writeln('1. Swordsman'),
    writeln('2. Archer'),
    writeln('3. Sorcerer'),
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
    asserta(acc(Acc_Name))
    /* STATUS TAMBAHAN */
    character_bonus_stat_update,
    /* TAMBAH KE INVENTORY */
    inventory_add(Weapon_Name),
    inventory_add(Armor_Name),
    inventory_add(Acc_Name),
    inventory_add_N(Potion_Name,5).

/* PEMBUATAN CHARACTER */
character_creation(X) :-
    X == 1,
    writeln('You choose swordsman, lets explore the world'),
    asserta(char(swordsman,1,0)),
    /* STATUS DASAR */
    asserta(attack(10,0)),
    asserta(defense(20,0)),
    asserta(max_HP(100)),
    asserta(health(100,0)).

character_creation(X) :-
    X == 2,
    writeln('You choose archer, lets explore the world'),
    asserta(char(archer,1,0)),
    /* STATUS DASAR */
    asserta(attack(20,0)),
    asserta(defense(10,0)),
    asserta(max_HP(100)),
    asserta(health(100,0)).

character_creation(X) :-
    X == 3,
    writeln('You choose sorcerer, lets explore the world'),
    asserta(char(sorcerer,1,0)),
    /* STATUS DASAR */
    asserta(attack(30,0)),
    asserta(defense(10,0)),
    asserta(max_HP(80)),
    asserta(health(80,0)).


/* MEKANISME LEVEL UP */
character_level_up :-
    /* PANGGIL VARIABEL CHARACTER */
    char(X,Y,Z),
    /* PERHITUNGAN LEVEL UP, EXP >= LEVEL*10 */
    Z >= Y*10,
    Yf is Y+1,
    Zf is Z-Y*10,
    /* UPDATE CHAR */
    retract(char(_,_,_)),
    asserta(char(X,Yf,Zf)),
    /* PERHITUNGAN STATUS BARU */
    attack(Att,BonusAtt),
    armor(Def,BonusDef),
    max_HP(MaxHP),
    health(Darah,BonusDarah)
    UP_Att is Att + Yf*2,
    UP_Dff is Dff + Yf*2,
    UP_MaxHP is MaxHP + Yf*10,
    UP_Darah is UP_MaxHP,
    /* UPDATE STATUS */
    retract(attack(_,_)),
    retract(armor(_,_)),
    retract(max_HP(_)),
    retract(health(_,_)),
    asserta(attack(UP_Att,BonusAtt)),
    asserta(armor(UP_Dff,BonusDef)),
    asserta(max_HP(UP_MaxHP)),
    asserta(health(UP_Darah,BonusDarah)).

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
    character_bonus_stat_acc(Acc_Name),


character_bonus_stat_weapon(Weapon_Name) :-
    /* Panggil Item */
    item_weapon(_,_,Weapon_Name,Weapon_Att),
    /* Hitung Bonus */
    attack(Att,BonusAtt),
    New_BonusAtt is BonusAtt+Weapon_Att,
    retract(attact(_,_)),
    asserta(attack(Att,New_BonusAtt)).

character_bonus_stat_armor(Armor_Name) :-
    /* Panggil Item */
    item_armor(_,Armor_Name,Armor_Def),
    /* Hitung Bonus */
    defense(Def,BonusDef),
    New_BonusDef is BonusDef+Armor_Def,
    retract(defense(_,_)),
    asserta(defense(Def,New_BonusDef)).

character_bonus_stat_acc(Acc_Name) :-
    /* Panggil Item */
    item_acc(Lv,Acc_Name,Efek),
    /* Hitung Bonus */
    Efek == health,
    health(HP,BonusHP),
    New_BonusHP is BonusHp + Lv*25,
    retract(health(_,_)),
    asserta(health(HP,New_BonusHP)).

character_bonus_stat_acc(Acc_Name) :-
    /* Panggil Item */
    item_acc(Lv,Acc_Name,Efek),
    /* Hitung Bonus */
    Efek == attack,
    attack(Att,BonusAtt),
    New_BonusAtt is BonusAtt + Lv*4,
    retract(attack(_,_)),
    asserta(attack(Att,New_BonusAtt)).

character_bonus_stat_acc(Acc_Name) :-
    /* Panggil Item */
    item_acc(Lv,Acc_Name,Efek),
    /* Hitung Bonus */
    Efek == defense,
    defense(Def,BonusDef),
    New_BonusDef is BonusDef + Lv*4,
    retract(defense(_,_)),
    asserta(defense(Def,New_BonusDef)).


/* BAGIAN MAP */

/* Ukuran peta : 12x22 */
/* Peta terdefinisi dari 0..11 dan 0..21 */
/* Hanya bisa diakses dari 1..10 dan 1..20 */

/* Menampilkan Peta */
map_show :-
    Y is 0,
    map_iterate_baris(Y). 

/* Iterasi Baris */
map_iterate_baris(12) :-    /* Basis */
    !.
map_iterate_baris(Y) :-     /* Rekurens */
    map_write_baris(X,Y),
    Next_Y is Y + 1,
    map_iterate_baris(Y).

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
    writeln("Your inventory:"),
    
/* BAGIAN ITEM */
/* MEKANISME MEMAKAI ITEM DARI INVENTORY (WEAPON,ARMOR,ACC) */
using_weapon(X,Y) :-
    inventory(Z),
    isMember(X,Z),
    item_weapon(_,Y,_,BonusATTACK),
    attack(CurrAtt, BonusCurrAtt),
    Temporary is CurrAtt,
    retract(attack(_,_)),
    asserta(attack(Temporary,BonusATTACK)).

using_armor(X) :-
    inventory(Z),
    isMember(X,Z),
    item_armor(_,_,BonusDEFENSE),
    defense(CurrDef, BonusCurrDef),
    Temporary is CurrDef,
    retract(defense(_,_)),
    asserta(defense(Temporary, BonusDEFENSE)).

/* MEKANISME MEMAKAI POTION */
using_potion(X) :-
    inventory(Z),
    isMember(X, Z),
    item_potion(_, _, ItemOption),
    ItemOption == defense,
    defense(CurrDef, BonusCurrDef),
    BonusCurrDef is BonusCurrDef + 1,
    Temporary is CurrDef,
    retract(defense(_,_)),
    asserta(defense(Temporary, )).
    inventory_del(X).

/* BAGIAN ENEMY */
calcDamageCommon([],0).
calcDamageCommon([H|Tail],X):-
    enemy_common(H), enemy_att(H,Att),
    calcDamageCommon(T,Xn),
    X is Xn+Att.

calcDamageBoss([],0).
calcDamageBoss([H|Tail],X):-
    enemy_boss(H), enemy_att(H,Att),
    calcDamageCommon(T,Xn),
    X is Xn+Att.

random_enemy :-
    random(1, 10, Enemy_1_X),
    random(1, 20, Enemy_1_Y),
    random(1, 10, Enemy_2_X),
    random(1, 20, Enemy_2_Y),
    random(1, 10, Enemy_3_X),
    random(1, 20, Enemy_3_Y),
    random(1, 10, Enemy_4_X),
    random(1, 20, Enemy_4_Y),
    random(1, 10, Enemy_5_X),
    random(1, 20, Enemy_5_Y),
    random(1, 10, Enemy_6_X),
    random(1, 20, Enemy_6_Y),
    random(1, 10, Enemy_7_X),
    random(1, 20, Enemy_7_Y),
    random(1, 10, Enemy_8_X),
    random(1, 20, Enemy_8_Y),
    random(1, 10, Enemy_9_X),
    random(1, 20, Enemy_9_Y),
    random(1, 10, Enemy_10_X),
    random(1, 20, Enemy_10_Y),
    /*Masukin ke map*/

/* BAGIAN QUEST */
quest :-

/* BAGIAN EXPLORATION MECHANISM */

/* BAGIAN BATTLE MECHANISM */


/* BAGIAN STORE */
store :-
    writeln("___________________________________"),
    writeln("  _____ _______ ____  _____  ______"),
    writeln(" / ____|__   __/ __ \|  __ \|  ____|"),
    writeln("| (___    | | | |  | | |__) | |__"),
    writeln(" \___ \   | | | |  | |  _  /|  __|"),  
    writeln(" ____) |  | | | |__| | | \ \| |____ "),
    writeln("|_____/   |_|  \____/|_|  \_\______|"),
    writeln("_____________________________________"),

    writeln('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'),
    writeln('%    Choose what you want to buy    %'),
    writeln('%                                   %'),
    writeln('%  1. Swordsman Weapon              %'),
    writeln('%  2. Archer Weapon                 %'),
    writeln('%  3. Sorcerer Weapon               %'),
    writeln('%  4. Armor                         %'),
    writeln('%  5. Accesories                    %'),
    writeln('%  6. Potion                        %'),
    read(X)
    
    X == 1,
    writeln('You choose Swordsman Weapon'),
    /* Randomize dan masukan ke Inventory */
    random(1, 3, Swordsman_Weapon),
    Swordsman_Weapon == 1,
    writeln('You get Wooden Sword'),

    Swordsman_Weapon == 2,
    writeln('You get Iron Sword'),

    Swordsman_Weapon == 3,
    writeln('You get Diamond Sword'),

    X == 2,
    writeln('You choose Archer Weapon'),
    /* Randomize dan masukan ke Inventory */
    random(1, 3, Archer_Weapon),
    Archer_Weapon == 1
    writeln('You get Wooden Bow'),

    Archer_Weapon == 2
    writeln('You get Iron Bow'),

    Archer_Weapon == 3
    writeln('You get Diamond Bow'),
    
    X == 3,
    writeln('You choose Sorcerer Weapon'),
    /* Randomize dan masukan ke Inventory */
    random(1, 3, Sorcerer_Weapon),
    Sorcerer_Weapon == 1
    writeln('You get Wooden Staff'),

    Archer_Weapon == 2,
    writeln('You get Iron Staff'),

    Archer_Weapon == 3,
    writeln('You get Diamond Staff'),

    X == 4,
    writeln('You choose Armor'),
    /* Randomize dan masukan ke Inventory */
    random(1, 3, Armor),
    Armor == 1
    writeln('You get Security Fest'),

    Armor == 2,
    writeln('You get Police Fest'),

    Armor == 3,
    writeln('You get Military Fest'),

    X == 5,
    writeln('You choose Accesories'),
    /* Randomize dan masukan ke Inventory */
    random(1, 3, Accessories),
    Accessories == 1
    writeln('You get Batu Akik'),

    Accessories == 2,
    writeln('You get Anting Jamet'),

    Accessories == 3,
    writeln('You get Topi Pramuka'),

    Accessories == 4,
    writeln('You get Kalung Corona'),

    Accessories == 5,
    writeln('You get Power Balance'),

    Accessories == 6,
    writeln('You get Masker'),

    
    X == 6,
    writeln('You choose Potion'),
    /* Potion tidak randomize langsung beli aja mang */


/* Display New Game*/
start :-
    writeln("________________________________________________________________"),
    writeln("/ ____|               | |   (_)        / ____|    | |       (_)"),
    writeln("| |  __  ___ _ __  ___| |__  _ _ __   | (___   ___| | _________"),
    writeln("| | |_ |/ _ \ '_ \/ __| '_ \| | '_ \   \___ \ / _ \ |/ / _` | |"),
    writeln("| |__| |  __/ | | \__ \ | | | | | | |  ____) |  __/   < (_| | |"),
    writeln("\______|\___|_| |_|___/_| |_|_|_| |_| |_____/ \___|_|\_\__,_|_|"),
    writeln("_______________________________________________________________"),

    writeln(""),
    writeln("Let's play and be a progammer"),
    writeln(''),
    
    writeln('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'),
    writeln('%                        ~Genshin Sekai~                         %'),
    writeln('%                                                                %'),
    writeln('%  1. start  : untuk memulai petualanganmu                       %'),
    writeln('%  2. map    : menampilkan peta                                  %'),
    writeln('%  3. status : menampilkan kondisimu terkini                     %'),
    writeln('%  4. w      : gerak ke utara 1 langkah                          %'),
    writeln('%  5. s      : gerak ke selatan 1 langkah                        %'),
    writeln('%  6. d      : gerak ke ke timur 1 langkah                       %'),
    writeln('%  7. a      : gerak ke barat 1 langkah                          %'),
    writeln('%  9. Status : menampilkan status pemain                         %'),
    writeln('%  8. help   : menampilkan segala bantuan                        %'),
    writeln('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%').
                                                               

/* Tampilan Help */
help :- writeln('_________________________________________________________________________________________'),
        writeln("________________________________________________________________"),
        writeln("/ ____|               | |   (_)        / ____|    | |       (_)"),
        writeln("| |  __  ___ _ __  ___| |__  _ _ __   | (___   ___| | ________"),
        writeln("| | |_ |/ _ \ '_ \/ __| '_ \| | '_ \   \___ \ / _ \ |/ / _` | |"),
        writeln("| |__| |  __/ | | \__ \ | | | | | | |  ____) |  __/   < (_| | |"),
        writeln("\______|\___|_| |_|___/_| |_|_|_| |_| |_____/ \___|_|\_\__,_|_|"),
        writeln("_______________________________________________________________"),
        writeln('Available commands:'),
        writeln(''),
        writeln('Legends:'),
        writeln('P = Player'),
        writeln('S = Store'),
        writeln('F = Hangar'),
        writeln('E = Enemy'),
        writeln('D = Boss Enemy'),
        writeln('Q = Quest'),
        writeln('# = Inaccessible Path'),
        writeln('- = Accessible Path'),

        writeln('__________________________________________________________________________________________').
        