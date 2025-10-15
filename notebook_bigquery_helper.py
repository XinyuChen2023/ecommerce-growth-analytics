"""
BigQuery helper functions for Jupyter notebooks
"""

from google.cloud import bigquery
import pandas as pd

def setup_bigquery_client(project_id="ecommerce-475102"):
    """Initialize BigQuery client"""
    try:
        client = bigquery.Client(project=project_id)
        print(f"✅ Connected to BigQuery project: {project_id}")
        return client
    except Exception as e:
        print(f"❌ Failed to connect to BigQuery: {e}")
        print("\nTo authenticate, run: gcloud auth application-default login")
        return None

def run_sql_query(client, sql_query, return_dataframe=True):
    """Run a SQL query and optionally return results as DataFrame"""
    try:
        print("🚀 Executing SQL query...")
        query_job = client.query(sql_query)
        
        if return_dataframe:
            # Return results as DataFrame
            df = query_job.to_dataframe()
            print(f"✅ Query executed successfully! Returned {len(df)} rows")
            return df
        else:
            # Just execute the query
            results = query_job.result()
            print("✅ Query executed successfully!")
            return results
            
    except Exception as e:
        print(f"❌ Query failed: {e}")
        return None

def run_sql_file(client, sql_file_path, return_dataframe=True):
    """Run a SQL file and optionally return results as DataFrame"""
    try:
        with open(sql_file_path, 'r') as f:
            sql_content = f.read()
        print(f"✅ Read SQL file: {sql_file_path}")
        return run_sql_query(client, sql_content, return_dataframe)
    except Exception as e:
        print(f"❌ Failed to read SQL file: {e}")
        return None

# Example usage in notebook:
"""
# Setup
client = setup_bigquery_client()

# Run the fact_orders_daily.sql file
df = run_sql_file(client, "src/sql/fact_orders_daily.sql")

# Or run a custom query
custom_query = '''
SELECT order_date, orders, revenue, units, aov
FROM `ecommerce-475102.shopify_clean.fact_orders_daily`
ORDER BY order_date DESC
LIMIT 10
'''
df = run_sql_query(client, custom_query)
"""
