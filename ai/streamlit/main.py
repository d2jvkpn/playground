#!/usr/bin/env python3
from datetime import datetime

import streamlit as st
import pandas as pd


data = pd.read_csv("data/sales.csv")
data['date'] = pd.to_datetime(data['date'])
data['month'] = data['date'].dt.month


selected_month = st.slider("筛选月份", 1, 12)
filtered_data = data[data['month'] == selected_month]

st.line_chart(filtered_data, x="date", y="revenue")
st.write("筛选后的数据", filtered_data)
