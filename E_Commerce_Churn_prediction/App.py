import streamlit as st
import joblib
import pandas as pd

st.title("E-Commerce Churn Prediction")

model = joblib.load('churn_model.pkl')

recency = st.number_input("Recency (days since last purchase)", min_value=0)
frequency = st.number_input("Frequency (number of purchases)", min_value=0)
monetary = st.number_input("Monetary (total spend)", min_value=0.0)
tenure = st.number_input("Tenure (days since first purchase)", min_value=0)
category_count = st.number_input("Category Count", min_value=0)

if st.button("Predict Churn"):
    customer = pd.DataFrame([[recency, frequency, monetary, tenure, category_count]],
                            columns=['Recency','Frequency','Monetary','Tenure','CategoryCount'])
    prob = model.predict_proba(customer)[:,1][0]
    st.metric("Churn Probability", f"{prob:.2%}")