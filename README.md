# 📉 Telecom Customer Churn: End-to-End Data Science Pipeline

One dataset, seven stages: **EDA → SQL → Feature Engineering → Machine Learning → Deep Learning → Dashboard → Deployment & Report**.

I am taking a single messy telecom dataset through the full data lifecycle, so each skill builds on the last. Every part has its own folder, notebook or SQL files, slides and results.

## 🛣️ Project Roadmap

| Part | Stage | Tools | Status |
|------|-------|-------|--------|
| 1 | [Exploratory Data Analysis](part1-eda/) | Python, Pandas, Seaborn | ✅ Complete |
| 2 | [SQL Analysis](part2-sql/) | MySQL, JOIN, GROUP BY, CASE | ✅ Complete |
| 3 | Feature Engineering | Python, scikit-learn | 🔜 Next |
| 4 | Machine Learning | scikit-learn | 🔜 Coming soon |
| 5 | Deep Learning | TensorFlow / Keras | 🔜 Coming soon |
| 6 | Interactive Dashboard | Power BI | 🔜 Coming soon |
| 7 | Deployment and Final Report | Streamlit | 🔜 Coming soon |

## 🎯 The Business Problem
A telecom company loses about **1 in 4 customers**. Each lost customer takes a monthly bill with them, and the retention team does not know where the churn comes from or who to save first. This project answers three questions:
1. **Where** does churn come from?
2. **How much money** does it cost?
3. **Who** should the company try to keep first?

## 📊 Headline Results

| Metric | Value |
|---|---|
| Customers analysed | 5,463 (after cleaning 5,500 raw records) |
| Overall churn rate | **22.7%** (1,238 customers)* |
| Monthly revenue lost to churn | **$86,284** (about $1.04M a year) |
| Month-to-Month vs Two-Year churn | 27.6% vs 14.7% |
| Fiber Optic vs DSL churn | 29.5% vs 18.0% |
| **High-risk segment** (Month-to-Month + Fiber Optic + Electronic Check) | **335 customers, 39.1% churn** vs 21.6% for everyone else |
| Monthly revenue in the high-risk segment | $27,974 ($17,138 still active and savable) |

\* The Part 1 slides show 22.6% because 22.66% was truncated. Rounded to one decimal, it is 22.7%.

---

## 📌 Part 1: Exploratory Data Analysis
**Goal:** clean a messy dataset end to end, find the drivers of churn, and turn findings into revenue-at-risk figures.

- **Data:** 5,500 raw records and 12 columns, reduced to 5,463 after cleaning. Target: `Churn` (Yes/No).
- **Cleaning (10+ issues):** 37 duplicate rows removed; tenure outliers (-3, 150, 999) capped to 0-72; currency text ("$18.00") converted to numbers; blank strings in `TotalCharges` fixed; casing and null-like strings standardised; missing values imputed with mode or median.
- **Findings:** Month-to-Month contracts churn about twice as much as Two-Year contracts. Fiber Optic users churn most (about 29%). Electronic Check payers churn more than auto-pay customers. The combined high-risk segment churns at 39.1%.
- **Business impact:** $86,284 a month already lost; $27,974 a month sits in a segment that is only about 6% of customers.

📁 Notebook, data and slides are in [`part1-eda/`](part1-eda/).

## 📌 Part 2: SQL Analysis
**Goal:** answer the business questions with SQL only, and turn the answers into an action plan.

- **Database:** 4 linked tables (`customers`, `services`, `contracts`, `billing`) built from the cleaned CSV through a staging table, with an ER diagram from MySQL Workbench.
- **Data quality checks first:** found that `TechSupport` contradicts `InternetService` for 1,824 customers.
- **10 business questions** using `JOIN`, `GROUP BY`, `CASE` and a subquery.
- **Findings:** 33% of customers leave in their first year. Tech Support has no effect on churn. Month-to-Month + Fiber loses $42,601 a month (about half of all lost revenue). SQL finds the same 39.1% high-risk segment as Python, and produces a retention call list.

📁 SQL files, ER diagram, slides and results are in [`part2-sql/`](part2-sql/).

## 📂 Repository Structure
```
Telecom-Customer-Churn-Analysis/
│
├── README.md
├── requirements.txt
├── .gitignore
│
├── data/
│   ├── telco_churn_dirty.csv
│   └── telco_churn_cleaned.csv
│
├── part1-eda/
│   ├── EDA_Project.ipynb
│   ├── Telecom_Customer_Churn_Analysis.pdf
│   └── Telecom_Customer_Churn_Analysis.pptx
│
├── part2-sql/
│   ├── README.md
│   ├── 01_create_tables.sql
│   ├── 02_data_quality_checks.sql
│   ├── 03_business_questions.sql
│   ├── ER_Model.mwb
│   ├── schema_diagram.png
│   └── Telecom_Churn_SQL_Project.pptx
│
├── part3-feature-engineering/  (coming soon)
├── part4-machine-learning/     (coming soon)
├── part5-deep-learning/        (coming soon)
├── part6-dashboard/            (coming soon)
└── part7-deployment-report/    (coming soon)
```

## ▶️ How to Run

**Part 1 (Python)**
```bash
git clone https://github.com/Shailesh-Pawar-18/Telecom-Customer-Churn-Analysis.git
cd Telecom-Customer-Churn-Analysis
pip install -r requirements.txt
jupyter notebook part1-eda/EDA_Project.ipynb
```

**Part 2 (MySQL 8.0+):** open MySQL Workbench, load `data/telco_churn_cleaned.csv` into the staging table, then run the three files in `part2-sql/` in order. Full steps are in [`part2-sql/README.md`](part2-sql/README.md).

## 🛠️ Tech Stack
Python · Pandas · NumPy · Matplotlib · Seaborn · Jupyter Notebook · MySQL · MySQL Workbench

## ⚠️ Notes
- Revenue lost means the monthly bill of customers who churned. It is an estimate, not accounting revenue.
- All findings are patterns in the data, not proven causes.

---

## 👤 Author
**Shailesh Pawar**
🔗 [LinkedIn](https://linkedin.com/in/shaileshpawar-cse) · 💻 [GitHub](https://github.com/Shailesh-Pawar-18)

⭐ If you find this useful, star the repo and follow along for Part 3: Feature Engineering!
