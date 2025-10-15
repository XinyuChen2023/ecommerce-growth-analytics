#!/usr/bin/env python3
"""
Script to run BigQuery SQL files
Usage: python run_sql.py [sql_file_path]
"""

import sys
import os
from pathlib import Path
from google.cloud import bigquery
from google.oauth2 import service_account

def run_sql_file(sql_file_path, project_id="ecommerce-475102"):
    """Run a SQL file against BigQuery"""
    
    # Initialize BigQuery client
    # You can either use service account credentials or default credentials
    try:
        # Try to use default credentials first (if you're authenticated via gcloud)
        client = bigquery.Client(project=project_id)
        print(f"✅ Connected to BigQuery project: {project_id}")
    except Exception as e:
        print(f"❌ Failed to connect to BigQuery: {e}")
        print("\nTo authenticate, run one of these commands:")
        print("1. gcloud auth application-default login")
        print("2. Or set GOOGLE_APPLICATION_CREDENTIALS environment variable")
        return False
    
    # Read SQL file
    try:
        with open(sql_file_path, 'r') as f:
            sql_content = f.read()
        print(f"✅ Read SQL file: {sql_file_path}")
    except Exception as e:
        print(f"❌ Failed to read SQL file: {e}")
        return False
    
    # Execute SQL
    try:
        print("🚀 Executing SQL query...")
        query_job = client.query(sql_content)
        results = query_job.result()  # Wait for the job to complete
        
        print("✅ Query executed successfully!")
        
        # If it's a SELECT query, show some results
        if sql_content.strip().upper().startswith('SELECT'):
            print("\n📊 Query Results (first 10 rows):")
            for i, row in enumerate(results):
                if i >= 10:
                    break
                print(row)
        else:
            print("📝 Non-SELECT query executed (CREATE, INSERT, UPDATE, etc.)")
            
        return True
        
    except Exception as e:
        print(f"❌ Query failed: {e}")
        return False

def main():
    if len(sys.argv) != 2:
        print("Usage: python run_sql.py <sql_file_path>")
        print("Example: python run_sql.py src/sql/fact_orders_daily.sql")
        sys.exit(1)
    
    sql_file = sys.argv[1]
    if not os.path.exists(sql_file):
        print(f"❌ SQL file not found: {sql_file}")
        sys.exit(1)
    
    success = run_sql_file(sql_file)
    sys.exit(0 if success else 1)

if __name__ == "__main__":
    main()
