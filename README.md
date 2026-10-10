[README (1).md](https://github.com/user-attachments/files/33278408/README.1.md)
# 📉 Telecom Customer Churn: End-to-End Data Pipeline

One dataset, seven stages: **EDA → SQL → Feature Engineering → Machine Learning → Deep Learning → Dashboard → Deployment & Report**.

I'm taking a single messy telecom dataset through the full data lifecycle to show how each skill builds on the last.

## 🛣️ Project Roadmap

| Part | Stage | Status |
|------|-------|--------|
| 1 | Exploratory Data Analysis (Python) | ✅ Complete |
| 2 | SQL Analysis | 🔜 Coming soon |
| 3 | Feature Engineering | 🔜 Coming soon |
| 4 | Machine Learning | 🔜 Coming soon |[requirements.txt](https://github.com/user-attachments/files/33278455/requirements.txt)
| 5 | Deep Learning | 🔜 Coming soon |
| 6 | Interactive Dashboard | 🔜 Coming soon |
| 7 | Deployment (Streamlit app) & Final Report | 🔜 Coming soon |

---

## 📌 Part 1: EDA

### Problem
Telecom companies lose recurring revenue when customers churn, but raw customer data is rarely clean enough to analyze or model directly.

### Objective
Clean a messy dataset end-to-end, find the drivers of churn, and convert findings into revenue-at-risk figures.

### Dataset

- **5,500** raw records, **12** columns, reduced to **5,463** after cleaning
- Target: `Churn` (Yes/No)
- File: [`data/telco_churn_dirty.csv`](data/telco_churn_dirty.csv)

### Data Cleaning (10+ issues fixed)
| Issue | Action |
|-------|--------|
| 37 exact duplicate rows | Removed with `drop_duplicates()` |
| Tenure outliers (-3, 150, 999) | Capped to the valid range 0-72 |
| Currency text in `MonthlyCharges` ("$18.00") | Stripped symbols, converted to numeric |
| Blank strings in `TotalCharges` | Converted to numeric, structural 0-impute for tenure = 0 |
| Casing and whitespace inconsistencies | Standardized |
| Null-like strings and nulls | Converted to NaN, imputed with mode or median |

### 🔍 Key Findings
- Overall churn rate: **22.6%**
- Month-to-Month customers churn ~**2x** more than Two-Year customers
- Fiber Optic users show the highest churn (~29%)
- Electronic Check payers churn more than auto-pay customers
- **High-risk segment** (Month-to-Month + Fiber Optic + Electronic Check): **39.1% churn** vs 21.6% for everyone else

### 💰 Business Impact
- **$86,284** monthly revenue already lost to churn (~$1.04M annualized)
- **$27,974** monthly revenue exposure in the high-risk segment (~$335K annualized)
- This segment is **~6% of customers** but **8.1% of revenue**

### 🛠️ Tech Stack
Python · Pandas · NumPy · Matplotlib · Seaborn · Jupyter Notebook

### 📂 Repository Structure
```
customer-churn-analysis-telecom/
│
├── README.md
├── requirements.txt
├── .gitignore
│
├── data/
│   └── telco_churn_dirty.csv
│
├── part1-eda/
│   ├── EDA_Project.ipynb
│   └── Telecom_Customer_Churn_Analysis.pdf
│
├── part2-sql/               (coming soon)
├── part3-feature-engineering/ (coming soon)
├── part4-machine-learning/  (coming soon)
├── part5-deep-learning/     (coming soon)
├── part6-dashboard/         (coming soon)
└── part7-deployment-report/ (coming soon)
```

### ▶️ How to Run
```bash
git clone https://github.com/Shailesh-Pawar-18/customer-churn-analysis-telecom.git
cd customer-churn-analysis-telecom
pip install -r requirements.txt
jupyter notebook part1-eda/EDA_Project.ipynb
```

---

## 👤 Author
**Shailesh Pawar**
🔗 [LinkedIn](https://linkedin.com/in/shaileshpawar-cse) · 💻 [GitHub](https://github.com/Shailesh-Pawar-18)

⭐ If you find this useful, star the repo and follow along for Part 2!

[Uploading requirements.txt…]()
