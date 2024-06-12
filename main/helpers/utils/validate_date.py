import datetime
import logging

logger = logging.getLogger(__name__)


class Validator:
    def __init__(self):
        pass

    # check valid date
    def validate(self, date_text):
        try:
            datetime.datetime.strptime(date_text, '%d-%m-%Y')
            return True
        except ValueError:
            logger.info('Incorrect date format, should be DD-MM-YYYY')
            return False
