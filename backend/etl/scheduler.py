from apscheduler.schedulers.background import BackgroundScheduler
from etl.fetch_bmkg import run_bmkg_etl
from etl.fetch_bnpb import run_bnpb_etl

def start_scheduler():
    scheduler = BackgroundScheduler()
    
    # Run BMKG ETL every 1 hour as requested
    scheduler.add_job(func=run_bmkg_etl, trigger="interval", hours=1)
    
    # Run BNPB ETL daily
    scheduler.add_job(func=run_bnpb_etl, trigger="interval", days=1)
    
    scheduler.start()
    print("ETL Scheduler started.")
