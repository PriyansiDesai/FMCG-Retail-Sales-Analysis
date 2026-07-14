import pandas as pd

df = pd.read_csv(r"C:\Users\priya\Downloads\train.csv")

result = df.groupby('Item_Type')['Item_Outlet_Sales'].sum().sort_values(ascending=False)
print(result)

total_revenue = df['Item_Outlet_Sales'].sum()
percentage = (result / total_revenue) * 100
print(percentage)

cumulative = percentage.cumsum()
print(cumulative)