# 🛒 E-commerce Database Project (MySQL)

This project is a **complete database system** for an e-commerce platform, built with **MySQL**.  

It includes:  
- 📂 Full **database schema**  
- 🧪 **Sample data** for testing  
- ⚡ **Advanced features** (triggers, stored procedures)  
- 🔍 Example **queries** to interact with the system  

---

## 🚀 How to Set Up

### 📌 Prerequisites
- [MySQL Server](https://dev.mysql.com/downloads/mysql/)  
- [MySQL Workbench](https://dev.mysql.com/downloads/workbench/)  

### ⚡ Installation Steps
1. Clone this repository or [download the ZIP](../../archive/refs/heads/main.zip).  
2. Open **MySQL Workbench**.  
3. Run the SQL scripts from the [`/sql_scripts/`](./sql_scripts) folder in the following order:  

   1. **[`1_Complete_Setup_MySQL.sql`](./sql_scripts/1_Complete_Setup_MySQL.sql)**  
      ➝ Creates the database and all tables.  

   2. **[`2_Sample_Data_MySQL.sql`](./sql_scripts/2_Sample_Data_MySQL.sql)**  
      ➝ Populates tables with sample data.  

   3. **[`3_Advanced_Features_MySQL.sql`](./sql_scripts/3_Advanced_Features_MySQL.sql)**  
      ➝ Adds triggers and stored procedures.  

   4. **[`4_Queries_MySQL.sql`](./sql_scripts/4_Queries_MySQL.sql)**  
      ➝ Example queries to test the database.  

---

## 🗄️ Database Schema
The final schema includes all tables and their relationships.  

📊 See the [`/diagrams/`](./diagrams) folder for both **conceptual** and **physical** ER diagrams.  

*(You can also embed an image directly if you want it to show inside README:)*  

```markdown
![ER Diagram](./diagrams/physical_ER.png)
