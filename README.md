# Football Scouting & Transfer Market Intelligence — MySQL Portfolio

> An end-to-end SQL analytics portfolio project built from a **small, real-data subset** of the Transfermarkt football dataset supplied for this project.

## Project goal

Instead of analysing an e-commerce store, this project applies the structure of the supplied SQL portfolio guide to a football scouting and transfer-market use case.

The guide's core expectations are a working MySQL database, 20+ business questions, a GitHub-ready structure, an ER diagram, documented queries, and a LinkedIn-ready project summary. This repository follows that structure while replacing customers/orders/products with football players, appearances and transfers. fileciteturn1file1L46-L60

## Why only 3 tables?

The original archive is very large. For a portfolio project, a smaller dataset is easier to understand, import and demonstrate. The guide explicitly notes that a huge dataset is not required and that query quality and business questions matter more. fileciteturn1file1L54-L60

This project therefore uses:
- **500 players**
- **12,000 appearances**
- **2,000 transfers**

These rows were selected directly from the supplied Transfermarkt archive; they are not synthetic/fake football records.

## Tables

```text
players
   │
   ├──────────────< appearances
   │
   └──────────────< transfers
```

### `players`
Player identity, position, nationality, club and market value.

### `appearances`
Match-level performance: goals, assists, minutes and cards.

### `transfers`
Transfer date, selling club, destination club, fee and market value.

## SQL skills demonstrated

- SELECT / WHERE / ORDER BY / LIMIT
- JOINs
- GROUP BY / HAVING
- Aggregate functions
- Subqueries
- CTEs
- RANK / DENSE_RANK
- LAG
- Window functions
- Views
- Stored procedures
- KPI-style scouting metrics

The query files contain **31 business/analytics questions**, each with a comment describing the business question, following the guide's recommendation. fileciteturn1file4L193-L195

## Repository structure

```text
football-scouting-sql-portfolio/
├── README.md
├── schema/
│   └── create_tables.sql
├── data/
│   ├── sample_players.csv
│   ├── sample_appearances.csv
│   ├── sample_transfers.csv
│   ├── import_sample_data.sql
│   
├── queries/
│   ├── 01_beginner_questions.sql
│   ├── 02_intermediate_questions.sql
│   └── 03_advanced_questions.sql
│
├── screenshots/
│   ├── er_diagram.png
│   └── beginner.png
│   └── advanced.png
│   └──intermediate.png
├── scripts/
   └── create_sample_from_archive.py
```

## How to run it in MySQL Workbench

### 1. Create the database

Open `schema/create_tables.sql` and run it.

### 2. Import the three CSVs

Open `data/import_sample_data.sql`.

Change the three Windows paths if your project folder is somewhere else.

Then run the script.

If `LOAD DATA LOCAL INFILE` is blocked by your MySQL installation, use MySQL Workbench's **Table Data Import Wizard** instead.

### 3. Validate

You should see approximately:

| Table | Rows |
|---|---:|
| players | 500 |
| appearances | 12,000 |
| transfers | 2,000 |

### 4. Run the questions

Run:
1. `queries/01_beginner_questions.sql`
2. `queries/02_intermediate_questions.sql`
3. `queries/03_advanced_questions.sql`

The guide recommends progressing through the questions in order and using them to demonstrate increasing SQL difficulty. fileciteturn1file3L162-L183

## Strong portfolio questions

Some of the best recruiter-facing questions are:

1. Who are the highest-valued players?
2. Which players produce the most goals and assists?
3. Which players have the best goals-per-90 output?
4. Which clubs spend the most on transfers?
5. Which clubs generate the most transfer income?
6. Who are the best-valued players within each position?
7. Which players look efficient relative to market value?
8. How has transfer spending changed over time?
9. What does a player's transfer and performance history look like?

## Dashboard

A Power BI build guide is included in `powerbi/POWER_BI_BUILD_GUIDE.md`.

Recommended pages:
- Player Scouting
- Transfer Market
- Value & Performance

## Source

The raw source is the Transfermarkt football dataset supplied with this project. The compact CSVs in this repository are a subset created from that archive.

## Data limitations

- This is a **portfolio-sized subset**, not the complete Transfermarkt dataset.
- Transfer fees may be 0 for reasons other than a literal zero-value economic transaction.
- Future-dated/scheduled transfers may exist in the source.
- The scouting score is a demonstration of SQL feature engineering, not a professional recruitment model.
- The project intentionally avoids pretending that a small sample can support real-world scouting decisions.

## What I learned

This project demonstrates how to move from raw football data to a relational SQL model and then to business-style analytics. I practiced aggregation, joins, CTEs and window functions, then added a dashboard-ready view and a stored procedure.

## LinkedIn draft

**Built a Football Scouting & Transfer Market Intelligence SQL project ⚽📊**

I transformed a real Transfermarkt football dataset into a compact MySQL analytics project focused on player performance, market value and transfers.

What I worked on:
- Designed a 3-table relational database for players, appearances and transfers
- Answered 30+ scouting and transfer-market business questions
- Used JOINs, CTEs, subqueries and window functions
- Built a dashboard-ready SQL view and a stored procedure
- Prepared the dataset for Power BI

One of the biggest takeaways: good analytics isn't about using the biggest dataset — it's about asking useful questions and building a clear path from raw data to insight.

#SQL #MySQL #DataAnalytics #FootballAnalytics #SportsAnalytics #PowerBI #DataAnalyst
