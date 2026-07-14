import pandas as pd

df = pd.read_csv(r"C:\Users\priya\Downloads\train.csv")

#for null values, taking avg of item weights
df['Item_Weight'] = df.groupby('Item_Identifier')['Item_Weight'].transform(
    lambda x: x.fillna(x.mean())
)
#for products who dont have any weight mentioned
df['Item_Weight'] = df['Item_Weight'].fillna(df['Item_Weight'].mean())

#fixing Outlet_Size nulls by filling using the most common size for that Outlet_Type
size_mode_by_type = df.groupby('Outlet_Type')['Outlet_Size'].agg(
    lambda x: x.mode()[0] if not x.mode().empty else 'Medium'
)
df['Outlet_Size'] = df.apply(
    lambda row: size_mode_by_type[row['Outlet_Type']] if pd.isna(row['Outlet_Size']) else row['Outlet_Size'],
    axis=1
)

# standardize Item_Fat_Content labels
df['Item_Fat_Content'] = df['Item_Fat_Content'].replace({
    'low fat': 'Low Fat',
    'LF': 'Low Fat',
    'reg': 'Regular'
})

#sanity checking as Item_Visibility of 0 is impossible for a product on shelf and treat as missing, fill with product-level mean
df['Item_Visibility'] = df['Item_Visibility'].replace(0, pd.NA)
df['Item_Visibility'] = df.groupby('Item_Identifier')['Item_Visibility'].transform(
    lambda x: x.fillna(x.mean())
)
df['Item_Visibility'] = df['Item_Visibility'].fillna(df['Item_Visibility'].mean())

#adding Outlet_Age for trend analysis (2013 = year dataset was compiled)
df['Outlet_Age'] = 2013 - df['Outlet_Establishment_Year']

#saving cleaned data
df.to_csv('bigmart_cleaned.csv', index=False)

print("Cleaned shape:", df.shape)
print("\nRemaining nulls:\n", df.isnull().sum())
print("\nFat content values now:", df['Item_Fat_Content'].unique())

from sqlalchemy import create_engine

engine = create_engine('postgresql://postgres:Priyu#2006@localhost:5432/bigmartproject')
df.to_sql('sales', engine, if_exists='replace', index=False)