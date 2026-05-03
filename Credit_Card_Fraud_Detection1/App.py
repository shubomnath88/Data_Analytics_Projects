import streamlit as st
import joblib
import pandas as pd

model = joblib.load('fraud_model.pkl')
scaler = joblib.load('scaler.pkl')

st.title("Credit card fraud detection")
amount = st.number_input("Enter amount $",min_value=0.0)
time = st.number_input("Enter Time (seconds since first transaction)", min_value=0, value=0)

if st.button("Predict"):
    input_data = pd.DataFrame({
        'Amount': [amount],
        'Time': [time]
    })

    # Scale the input
    input_scaled = scaler.transform(input_data)
    
    # Convert to DataFrame with correct column names
    input_scaled_df = pd.DataFrame(input_scaled, columns=['Amount_Scaled', 'Time_Scaled'])

    prediction = model.predict(input_scaled_df)

    if prediction == 1:
        st.error("Fraud Detected")
    else:
        st.success("Normal Transaction")
