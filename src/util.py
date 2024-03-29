import os
import logging
from datetime import datetime
logging.basicConfig(filename='example.log', level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
class Logger:
    def __init__(self):
        self.logger = logging.getLogger(__name__)
        self.timestamp = self._get_timestamp()

    def log_info(self, message):
        self.logger.info(f"{self._get_timestamp()} - {message}'.")
    
    def _get_timestamp(self):
        return datetime.now().strftime('%Y-%m-%d %H:%M:%S')