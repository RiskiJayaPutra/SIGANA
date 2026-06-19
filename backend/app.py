from flask import Flask
from controllers.map_controller import map_bp
from controllers.stats_controller import stats_bp
from controllers.etl_controller import etl_bp
from etl.scheduler import start_scheduler

def create_app():
    app = Flask(__name__)
    
    # Enable CORS for development
    from flask_cors import CORS
    CORS(app)

    # Register blueprints
    app.register_blueprint(map_bp)
    app.register_blueprint(stats_bp)
    app.register_blueprint(etl_bp)

    @app.route('/')
    def index():
        return {"message": "SIGANA API is running. Access /api/banjir, /api/tsunami, etc."}

    # Start the APScheduler for ETL
    start_scheduler()
    
    return app

# Create app instance for gunicorn (production)
app = create_app()

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True, use_reloader=False) # Disable reloader with scheduler
