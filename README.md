Engeto SQL Analytický Projekt
Datově‑analytický projekt zaměřený na ekonomické trendy v České republice. Využívá data o mzdách, cenách potravin a HDP a obsahuje pět samostatných SQL dotazů. Každý dotaz odpovídá na konkrétní ekonomickou otázku a ukazuje praktické použití analytických SQL funkcí.

Projekt 1: Trendy růstu mezd v odvětvích
Otázka: Rostou mzdy ve všech odvětvích, nebo někde klesají?

Popis:

Výpočet meziročních změn mezd.

Použití LAG() pro porovnání s předchozím rokem.

Klasifikace trendu (růst / pokles / beze změny).

Zjištění:

Mzdy dlouhodobě rostou ve všech odvětvích (2000–2021).

Nejrychlejší růst: IT/komunikace.

Výjimky poklesu: nemovitosti (2013, 2020) a IT (2013).

Projekt 2: Kupní síla (2006 vs. 2018)
Otázka: Kolik mléka a chleba lze koupit za průměrnou mzdu v prvním a posledním dostupném období?

Popis:

Porovnání kupní síly mezi roky 2006 a 2018.

Výpočet množství potravin za měsíční mzdu.

Zjištění:

Mléko: 1408,75 l → 1613,53 l (+14,5 %).

Chléb: 1261,93 kg → 1319,32 kg (+4,5 %).

Mzdy rostly rychleji než ceny potravin, kupní síla se zvýšila.

Projekt 3: Inflace potravin
Otázka: Které potraviny zdražují nejpomaleji?

Popis:

Výpočet průměrného meziročního růstu cen.

Seřazení od nejnižší inflace po nejvyšší.

Zjištění:

Nejnižší růst: cukr (-1,92 %), rajčata (-0,74 %).

Nejvyšší růst: papriky (7,29 %), máslo (6,68 %).

Inflace potravin je velmi rozdílná napříč kategoriemi.

Projekt 4: Rozdíl mezi růstem mezd a cen potravin
Otázka: Byl někdy růst cen potravin o více než 10 % vyšší než růst mezd?

Popis:

Porovnání meziročních procentuálních změn.

Výpočet rozdílu mezi růstem mezd a cen.

Zjištění:

Žádný rok nepřekročil hranici 10 %.

Největší rozdíl: 2009 (mzdy +3,26 %, ceny -6,41 % → rozdíl -9,66 %).

Mzdy a ceny se dlouhodobě pohybují relativně synchronně.

Projekt 5: Vliv HDP na mzdy a ceny
Otázka: Má růst HDP vliv na změny mezd a cen potravin?

Popis:

Spojení dat HDP, mezd a cen.

Výpočet meziročních změn a sledování korelací.

Zjištění:

Růst HDP se často projeví růstem mezd, ale se zpožděním.

Ceny reagují na HDP citlivěji než mzdy.

Krize 2009: HDP klesl, mzdy dál rostly (zpožděný efekt).
