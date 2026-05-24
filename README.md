# 📊 Engeto SQL Analytický Projekt

Komplexní datově‑analytický projekt zkoumající ekonomické trendy v České republice prostřednictvím dat o mzdách, cenách potravin a HDP. Projekt obsahuje 5 analytických SQL dotazů, které zkoumají vztahy mezi růstem mezd, inflací potravin a makroekonomickými ukazateli.

[![SQL](https://img.shields.io/badge/SQL-CC2927?style=flat-square&logo=microsoft-sql-server&logoColor=white)](https://en.wikipedia.org/wiki/SQL)
[![Data Analysis](https://img.shields.io/badge/Data%20Analysis-4CAF50?style=flat-square)](#)
[![Czech Republic](https://img.shields.io/badge/Ekonomika-Česká%20republika-blue?style=flat-square)](#)

---

## 📋 Přehled projektu

Projekt analyzuje česká ekonomická data z let 2006–2018 pomocí SQL dotazů, které odpovídají na 5 klíčových ekonomických otázek týkajících se růstu mezd, kupní síly, inflace potravin a makroekonomických trendů.

---

## 🔍 Rozpis projektů

### **Projekt 1: Trendy růstu mezd v jednotlivých odvětvích**

**Otázka:** *Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?*

**Co dotaz dělá:**
- Analyzuje meziroční změny mezd ve všech odvětvích
- Používá `LAG()` pro porovnání s předchozím rokem
- Klasifikuje trend jako „růst", „pokles" nebo „bez změny"

**Hlavní zjištění (CSV):**
- ✅ **Všechna odvětví vykazují růst mezd** v období 2000–2021 (s výjimkami)
- Největší růst: IT/komunikace (21 591 → 62 433 Kč)
- Pouze 2 výjimečné poklesy: nemovitosti (2013, 2020) a IT (2013)
- Celkový trend: mzdy dlouhodobě rostou napříč všemi sektory

**CSV:** `Engeto projekt 1.csv` (45 KB, 22+ odvětví × 22 let)

---

### **Projekt 2: Analýza kupní síly**

**Otázka:** *Kolik litrů mléka a kilogramů chleba je možné koupit za průměrnou mzdu v prvním a posledním dostupném období?*

**Co dotaz dělá:**
- Porovnává kupní sílu v roce 2006 a 2018
- Vypočítává množství mléka a chleba dostupné za měsíční mzdu
- Ukazuje, jak inflace ovlivňuje reálnou kupní sílu

**Hlavní zjištění:**
- **Mléko 2006:** 1 408,75 l
- **Mléko 2018:** 1 613,53 l **(+14,5 %)**
- **Chléb 2006:** 1 261,93 kg
- **Chléb 2018:** 1 319,32 kg **(+4,5 %)**
- **Závěr:** Kupní síla vzrostla, protože mzdy rostly rychleji než ceny potravin

**CSV:** `Engeto projekt 2.csv` (jednoduchá srovnávací tabulka)

---

### **Projekt 3: Žebříček inflace potravin**

**Otázka:** *Která kategorie potravin zdražuje nejpomaleji?*

**Co dotaz dělá:**
- Počítá průměrný meziroční růst cen pro 27 kategorií potravin
- Seřazuje je podle inflace (od nejnižší po nejvyšší)
- Identifikuje potraviny s nejstabilnějšími a nejméně stabilními cenami

**Hlavní zjištění:**

| Pořadí | Potravina | Průměrný růst/rok |
|--------|-----------|-------------------|
| 1 | Cukr | **-1,92 %** |
| 2 | Rajčata | -0,74 % |
| 3 | Banány | 0,81 % |
| ... | ... | ... |
| 26 | Máslo | 6,68 % |
| 27 | Papriky | **7,29 %** |

- **Nejstabilnější:** cukr, rajčata (dokonce zlevňují)
- **Nejméně stabilní:** papriky, máslo, vejce
- **Rozptyl inflace:** od -1,92 % do +7,29 % – obrovský rozdíl!

**CSV:** `Engeto projekt 3.csv` (27 potravin seřazeno podle inflace)

---

### **Projekt 4: Analýza rozdílu mezi růstem mezd a cen potravin**

**Otázka:** *Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?*

**Co dotaz dělá:**
- Porovnává meziroční růst mezd a cen potravin
- Počítá procentuální rozdíl
- Označuje roky, kde rozdíl překročí 10 %

**Hlavní zjištění:**

| Rok | Růst mezd | Růst cen | Rozdíl | Příznak |
|-----|-----------|----------|--------|---------|
| 2007 | +6,78 % | +6,75 % | -0,03 % | ❌ |
| 2008 | +7,46 % | +6,19 % | -1,87 % | ❌ |
| 2009 | +3,26 % | -6,41 % | -9,66 % | ❌ |

- **❌ Žádný rok nepřekročil hranici 10 %**
- Největší rozdíl: 2009 (mzdy rostly, ceny potravin klesly → rozdíl -9,66 %)
- Mzdy a ceny potravin se dlouhodobě pohybují relativně synchronně
- Kupní síla je stabilní a rostoucí

**CSV:** `Engeto projekt 4.csv` (13 řádků, data 2006–2018)

---

### **Projekt 5: Vliv HDP na mzdy a ceny potravin**

**Otázka:** *Má výše HDP vliv na změny mezd a cen potravin? Projeví se výrazný růst HDP ve stejném nebo následujícím roce na růstu mezd či cen?*

**Co dotaz dělá:**
- Kombinuje data HDP, mezd a cen potravin
- Počítá meziroční změny všech tří ukazatelů
- Umožňuje sledovat korelace mezi makroekonomikou a životní úrovní

**Hlavní zjištění:**

| Rok | Změna HDP | Změna mezd | Změna cen | Pozorování |
|-----|-----------|-----------|-----------|-----------|
| 2007 | +10,99 mld | +1 383 Kč | +3,07 % | Růst HDP → růst mezd ✓ |
| 2008 | +5,60 mld | +1 750 Kč | +3,01 % | Růst HDP → růst mezd ✓ |
| 2009 | -9,97 mld | +763 Kč | -3,31 % | Krize → stagnace mezd, deflace |
| 2017 | +12,05 mld | +1 789 Kč | +5,44 % | Silný růst HDP → růst mezd ✓ |

**Závěry:**
- 📉 **Korelace je slabá a zpožděná** (HDP a mzdy se nesynchronizují okamžitě)
- Růst HDP neznamená automaticky okamžitý růst mezd
- Ceny reagují na HDP citlivěji než mzdy
- Mzdy jsou stabilnější a méně volatilní
- 2009 krize: HDP se zhroutil, ale mzdy pokračovaly v růstu (zpoždění)

**CSV:** `Engeto projekt 5.csv` (24 let dat HDP, mezd, cen)

---

## 📁 Struktura projektu

```
Engeto_10.02.2026/
├── README.md (tento soubor)
├── Engeto projekt 1.sql           # Analýza trendů mezd
├── Engeto projekt 1.csv           # Výstup: trendy mezd podle odvětví
├── Engeto projekt 2.sql           # Srovnání kupní síly
├── Engeto projekt 2.csv           # Výstup: cena mléka a chleba
├── Engeto projekt 3.sql           # Žebříček inflace potravin
├── Engeto projekt 3.csv           # Výstup: 27 potravin seřazeno
├── Engeto projekt 4.sql           # Detekce rozdílů mzdy-ceny
├── Engeto projekt 4.csv           # Výstup: meziroční analýza
├── Engeto projekt 5.sql           # Korelace HDP
├── Engeto projekt 5.csv           # Výstup: trendy HDP/mzdy/ceny
├── jakub_fecik_project_sql_primary_final.sql      # Primární datový dump
├── jakub_fecik_project_sql_primary_final.csv      # Primární dataset
├── jakub_fecik_project_SQL_secondary_final.sql    # Sekundární tabulka
└── Sekundární tabulka.csv         # Sekundární dataset
```
---

## 🛠️ Technická implementace

### Používané SQL techniky:
- **Window Functions:** `LAG()`, `DENSE_RANK()`, `PARTITION BY`
- **CTEs (Common Table Expressions):** Víceúrovňová transformace dat
- **Agregace:** `AVG()`, `GROUP BY` pro roční/kategoriální analýzy
- **Datumové funkce:** Extrakce roku, porovnání dat
- **Logika meziročního srovnání:** `LAG()` pro předchozí období

### Zdroje dat:
- `jakub_fecik_project_SQL_primary_final` - Hlavní sloučený dataset
  - Obsahuje: mzdy v odvětvích, ceny potravin, roční agregáty
  - Období: 2000-2021 pro mzdy, 2006-2018 pro ceny potravin
  - 1M+ záznamů s normalizovanou strukturou

---

## 📊 Shrnutí projektů

| Projekt | Otázka | Odpověď | Zjištění |
|---------|--------|---------|----------|
| **1** | Rostou mzdy všude? | 5 CTEs, LAG() | ✅ ANO (všechny rostou, 2 výjimky) |
| **2** | Kupní síla 2006→2018? | Poměr mzda/cena | ✅ ZVÝŠENA (+14,5 % mléko, +4,5 % chléb) |
| **3** | Nejpomalejší inflace? | DENSE_RANK() | ❄️ CUKR (-1,92 %), PAPRIKY (+7,29 %) |
| **4** | Rok s 10%+ rozdílem? | Procentuální gap | ❌ NE (nikdy nepřekročilo 10 %) |
| **5** | HDP vliv na ceny/mzdy? | Korelace | 📉 SLABÝ (zpožděný/nepřímý efekt) |

---

## 💡 Klíčové ekonomické poznatky

1. **Růst mezd je robustní:** České mzdy důsledně rostou ve všech sektorech (bez širokého poklesu)
2. **Životní úroveň se zlepšuje:** Češi si mohou koupit VÍC potravin za stejnou mzdu
3. **Inflace potravin je rozmanitá:** Některé potraviny zlevňují (cukr), jiné inflují 7%+ ročně
4. **Rovnováha mzdy-cena:** Růst mezd překonává inflaci potravin → dobré pro kupní sílu
5. **HDP efekt je slabý:** Změny HDP se okamžitě neprojeví na mzdách/cenách (zpoždění)

---

## 📝 Poznámky

- **Kvalita dat:** Založeno na oficiálních ekonomických statistikách ČR
- **Časové pokrytí:** Mzdy 2000-2021; Ceny 2006-2018; HDP 1999-2020
- **Geografický rozsah:** Pouze Česká republika
- **Komentáře:** SQL soubory obsahují komentáře v češtině/slovenštině vysvětlující logiku

---

## 👨‍💻 Autor

**Jakub8b**  
Projekt: Engeto SQL Course  
Datum: 10. února 2026

